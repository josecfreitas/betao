-- Player
DROP TABLE IF EXISTS player cascade;

CREATE TABLE player(
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL
);

INSERT INTO
  player(id, name)
VALUES
  ('68f8f218-26f4-4388-ba58-259ffe185d53', 'José');

-- Game
DROP TABLE IF EXISTS game cascade;

CREATE TABLE game(
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  bet_price REAL NOT NULL,
  starts_at DATE NOT NULL,
  ends_at DATE NOT NULL,
  seller_commission_percentage SMALLINT NOT NULL,
  system_commission_percentage SMALLINT NOT NULL
);

INSERT INTO
  game(
    id,
    name,
    bet_price,
    starts_at,
    ends_at,
    seller_commission_percentage,
    system_commission_percentage
  )
VALUES
  (
    '59cd7565-6290-4785-97b1-a888963c1ce0',
    'Rodada da Morte',
    10.00,
    NOW(),
    NOW(),
    15,
    5
  );

-- Game Matches
DROP TYPE IF EXISTS match_result cascade;

CREATE TYPE match_result AS ENUM ('HOME', 'AWAY', 'DRAW');

DROP TABLE IF EXISTS game_match cascade;

CREATE TABLE game_match(
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  home TEXT NOT NULL,
  away TEXT NOT NULL,
  result match_result,
  game_id uuid NOT NULL REFERENCES game(id)
);

INSERT INTO
  game_match(id, home, away, result, game_id)
VALUES
  (
    '93b6673b-5424-4b58-be8e-b4a02ef72387',
    'Santos',
    'Corinthians',
    'HOME',
    '59cd7565-6290-4785-97b1-a888963c1ce0'
  ),
  (
    '1146fd27-539a-4ad8-8389-54288ba3bab4',
    'Palmeiras',
    'São Paulo',
    'AWAY',
    '59cd7565-6290-4785-97b1-a888963c1ce0'
  );

-- Bet
DROP TABLE IF EXISTS bet cascade;

CREATE TABLE bet(
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  player_id uuid NOT NULL REFERENCES player(id),
  game_id uuid NOT NULL REFERENCES game(id),
  price REAL NOT NULL,
  quantity INT NOT NULL,
  hits INT
);

INSERT INTO
  bet(id, player_id, game_id, price, quantity)
VALUES
  (
    '6126db8e-fee1-4a3c-9afc-609f115383a0',
    '68f8f218-26f4-4388-ba58-259ffe185d53',
    '59cd7565-6290-4785-97b1-a888963c1ce0',
    (
      SELECT
        bet_price
      FROM
        game
      WHERE
        id = '59cd7565-6290-4785-97b1-a888963c1ce0'
    ),
    1
  ),
  (
    'dad6d93d-5a11-4080-ac2b-8aac7fc64ff6',
    '68f8f218-26f4-4388-ba58-259ffe185d53',
    '59cd7565-6290-4785-97b1-a888963c1ce0',
    (
      SELECT
        bet_price
      FROM
        game
      WHERE
        id = '59cd7565-6290-4785-97b1-a888963c1ce0'
    ),
    2
  );

-- Bet Results
DROP TABLE IF EXISTS bet_match cascade;

CREATE TABLE bet_match(
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  bet_id uuid NOT NULL REFERENCES bet(id),
  game_match_id uuid NOT NULL REFERENCES game_match(id),
  result match_result
);

INSERT INTO
  bet_match(bet_id, game_match_id, result)
VALUES
  (
    '6126db8e-fee1-4a3c-9afc-609f115383a0',
    '93b6673b-5424-4b58-be8e-b4a02ef72387',
    'HOME'
  ),
  (
    '6126db8e-fee1-4a3c-9afc-609f115383a0',
    '1146fd27-539a-4ad8-8389-54288ba3bab4',
    'AWAY'
  ),
  (
    'dad6d93d-5a11-4080-ac2b-8aac7fc64ff6',
    '93b6673b-5424-4b58-be8e-b4a02ef72387',
    'AWAY'
  ),
  (
    'dad6d93d-5a11-4080-ac2b-8aac7fc64ff6',
    '1146fd27-539a-4ad8-8389-54288ba3bab4',
    'AWAY'
  );

-- Game and match results
DROP view IF EXISTS game_matches_agg;

CREATE
OR REPLACE view game_matches_agg AS
SELECT
  game.*,
  array_agg(
    concat(
      game_match.home,
      ' [',
      game_match.result,
      '] ',
      game_match.away
    )
  ) AS matches
FROM
  game
  JOIN game_match ON (game.id = game_match.game_id)
GROUP BY
  game.id;

-- Bet and match results
DROP view IF EXISTS bet_matches_agg;

CREATE
OR REPLACE view bet_matches_agg AS
SELECT
  bet.*,
  array_agg(
    concat(
      game_match.home,
      ' [',
      bet_match.result,
      '] ',
      game_match.away
    )
  ) AS matches,
  array_agg(game_match.result) AS game_results,
  array_agg(bet_match.result) AS bet_results,
  array_agg(game_match.result = bet_match.result) AS hits_agg,
  count(1) FILTER (
    WHERE
      game_match.result = bet_match.result
  ) AS hits_count
FROM
  bet
  JOIN bet_match ON (bet.id = bet_match.bet_id)
  JOIN game_match ON (bet_match.game_match_id = game_match.id)
GROUP BY
  bet.id;

-- Bet Ranking result
DROP view IF EXISTS bet_ranking_result;

CREATE
OR REPLACE view bet_ranking_result AS
SELECT
  bet.id,
  player.name,
  bet.quantity,
  bet.price,
  game_matches_agg.matches,
  bet_matches_agg.matches AS bet_matches,
  bet_matches_agg.hits_count AS hits_count
FROM
  bet
  JOIN player ON (bet.player_id = player.id)
  JOIN game_matches_agg ON (bet.game_id = game_matches_agg.id)
  JOIN bet_matches_agg ON (bet.id = bet_matches_agg.id)
ORDER BY
  hits_count DESC;

-- Update bet with results
UPDATE
  bet
SET
  hits = hits_query.hits_count
FROM
  (
    SELECT
      bet.id AS bet_id,
      count(1) FILTER (
        WHERE
          game_match.result = bet_match.result
      ) AS hits_count
    FROM
      bet
      JOIN bet_match ON (bet.id = bet_match.bet_id)
      JOIN game_match ON (bet_match.game_match_id = game_match.id)
    WHERE
      bet.hits is null
      AND game_match.result is not null
    GROUP BY
      bet.id
  ) AS hits_query
WHERE
  hits_query.bet_id = bet.id
