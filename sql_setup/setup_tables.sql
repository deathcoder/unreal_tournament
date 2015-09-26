/*
the only problem I see there is that a player can compete in a competition in a tournament they're not registered for

to enforce that, add tournament to opponent, and do (tournament) reference tournament (id), (registration, tournament) references registration (id, tournament), (competition,tournament) references compentiton (id, tournament)

the reference to tournament(id) is not strictly necessary

the key is that opponent(tournament) references both competition(tournament) and registration(tournament)

AND:
 a player can rank in a position is not present in the competition pts_table!!!
 */
CREATE TABLE player (
  id       BIGSERIAL NOT NULL UNIQUE PRIMARY KEY,
  username TEXT      NOT NULL UNIQUE,
  password TEXT NOT NULL,
  name     TEXT,
  surname  TEXT,
  enabled  BOOL      NOT NULL DEFAULT TRUE,
  admin    BOOL      NOT NULL DEFAULT FALSE
);

CREATE TABLE tournament (
  id           BIGSERIAL NOT NULL UNIQUE PRIMARY KEY,
  name         TEXT      NOT NULL UNIQUE CONSTRAINT tour_name_len_gte_3 CHECK (length(name) >= 3),
  edition      TEXT      NOT NULL DEFAULT 'first',
  type         TEXT      NOT NULL DEFAULT 'italian',
  competitions INT       NOT NULL,
  min_regs     INT       NOT NULL DEFAULT 2 CONSTRAINT minregs_gte_2 CHECK (min_regs >= 2),
  max_regs     INT       NOT NULL DEFAULT 2 CONSTRAINT maxregs_gte_minregs CHECK (max_regs >= tournament.min_regs),
  enabled      BOOL      NOT NULL DEFAULT FALSE, /* todo: add trigger check */
  start_reg    DATE,
  end_reg      DATE CONSTRAINT endregs_gt_startreg CHECK (end_reg > tournament.start_reg),
  organizer    BIGINT    NOT NULL REFERENCES player (id),
  CONSTRAINT uniq_name_edition UNIQUE (name, edition)
);


CREATE TABLE registration (
  id         BIGSERIAL      NOT NULL UNIQUE PRIMARY KEY,
  player     BIGINT         NOT NULL REFERENCES player (id),
  fee        DECIMAL(12, 2) NOT NULL,
  points     INT CONSTRAINT regpoints_gte_0 CHECK (points >= 0) DEFAULT 0,
  tournament BIGINT         NOT NULL REFERENCES tournament (id),
  CONSTRAINT uniq_player_reg_to_a_tournament UNIQUE (player, tournament),
  CONSTRAINT postgres_wants_uniq_for_reference1 UNIQUE (id, tournament)
);

CREATE TABLE reward (
  tournament BIGINT NOT NULL REFERENCES tournament (id),
  rank       INT    NOT NULL CONSTRAINT reward_rank_gte_1 CHECK (rank >= 1),
  reward     TEXT   NOT NULL,
  PRIMARY KEY (tournament, rank)
);

CREATE TABLE pts_table (
  id        BIGSERIAL NOT NULL UNIQUE,
  type      TEXT      NOT NULL CONSTRAINT type_len_gte_3 CHECK (length(type) >= 3),
  rank      INT       NOT NULL CONSTRAINT pts_table_rank_gte_1 CHECK (rank >= 1),
  award_pts INT       NOT NULL CONSTRAINT tab_pts_gte_0 CHECK (award_pts >= 0),
  CONSTRAINT uniq_type_rank UNIQUE (type, rank),
  PRIMARY KEY (id, rank)
);

CREATE TABLE competition (
  id         BIGSERIAL NOT NULL UNIQUE PRIMARY KEY,
  name       TEXT NOT NULL CONSTRAINT competition_name_len_gte_3 CHECK (length(name) >= 3),
  play_date  TIMESTAMP    NOT NULL DEFAULT now(),
  phase      TEXT      NOT NULL DEFAULT 'phase 1',
  enabled    BOOL      NOT NULL DEFAULT FALSE, /* todo: add trigger check */
  pts_ref    BIGINT    NOT NULL REFERENCES pts_table (id),
  tournament BIGINT    NOT NULL REFERENCES tournament (id),

  CONSTRAINT uniq_name_tournament UNIQUE (name, tournament),
  CONSTRAINT postgres_wants_uniq_for_reference2 UNIQUE (id, tournament)
);

CREATE TABLE opponent (
  registration BIGINT NOT NULL REFERENCES registration (id),
  competition  BIGINT NOT NULL REFERENCES competition (id),
  ranking      INT CONSTRAINT ranking_gte_0 CHECK (ranking >= 0),
  /* enforce that a player can compete only in a competition in a tournament they're registered for */
  tournament   BIGINT NOT NULL REFERENCES tournament(id),
  CONSTRAINT same_tournament_registration FOREIGN KEY (registration, tournament) REFERENCES registration (id, tournament),
  CONSTRAINT same_tournament_competition FOREIGN KEY (competition, tournament) REFERENCES competition (id, tournament),

  /* end enforcement */
  PRIMARY KEY (registration, competition)
);