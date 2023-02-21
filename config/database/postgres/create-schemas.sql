CREATE TABLE public.COLLABORATOR (
  id            SERIAL        NOT NULL PRIMARY KEY,
  email         VARCHAR(255)  NOT NULL UNIQUE,
  creation_date DATE
);

CREATE TABLE public.USER (
  colaborator_id      SERIAL        NOT NULL PRIMARY KEY,
  authentication_type CHAR          NOT NULL,
  authenticator_uri   VARCHAR(255),
  cas_uid             VARCHAR(255),
  firstname           VARCHAR(255)  NOT NULL,
  lastname            VARCHAR(255)  NOT NULL,
  password            VARCHAR(255)  NOT NULL,
  activation_code     BIGINT        NOT NULL,
  activation_date     DATE,
  allow_send_email    CHAR          NOT NULL DEFAULT 0,
  locale              VARCHAR(5),
  google_sync         BOOL,
  sync_code           VARCHAR(255),
  google_token        VARCHAR(255),
  FOREIGN KEY (colaborator_id) REFERENCES public.COLLABORATOR (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

CREATE TABLE public.MINDMAP (
  id             SERIAL       NOT NULL PRIMARY KEY,
  title          VARCHAR(255) NOT NULL,
  description    VARCHAR(255) NOT NULL,
  xml            BYTEA        NOT NULL,
  public         BOOL         NOT NULL DEFAULT FALSE,
  creation_date  TIMESTAMP,
  edition_date   TIMESTAMP,
  creator_id     INTEGER      NOT NULL,
  last_editor_id INTEGER      NOT NULL,
  FOREIGN KEY (creator_id) REFERENCES public.USER (colaborator_id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

CREATE TABLE public.LABEL (
  id              SERIAL       NOT NULL PRIMARY KEY,
  title           VARCHAR(30)
                  NOT NULL,
  creator_id      INTEGER      NOT NULL,
  parent_label_id INTEGER,
  color           VARCHAR(7)   NOT NULL,
  iconName        VARCHAR(50)  NOT NULL,
  FOREIGN KEY (creator_id) REFERENCES public.USER (colaborator_id),
  FOREIGN KEY (parent_label_id) REFERENCES LABEL (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

CREATE TABLE public.R_LABEL_MINDMAP (
  mindmap_id       INTEGER  NOT NULL,
  label_id         INTEGER  NOT NULL,
  PRIMARY KEY (mindmap_id, label_id),
  FOREIGN KEY (mindmap_id) REFERENCES public.MINDMAP (id),
  FOREIGN KEY (label_id) REFERENCES public.LABEL (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

CREATE TABLE public.MINDMAP_HISTORY (
 id            SERIAL     NOT NULL PRIMARY KEY,
 xml           BYTEA      NOT NULL,
 mindmap_id    INTEGER    NOT NULL,
 creation_date TIMESTAMP,
 editor_id     INTEGER    NOT NULL,
  FOREIGN KEY (mindmap_id) REFERENCES public.MINDMAP (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

CREATE TABLE public.COLLABORATION_PROPERTIES (
  id                 SERIAL NOT NULL PRIMARY KEY,
  starred            BOOL   NOT NULL DEFAULT FALSE,
  mindmap_properties VARCHAR(512)
);

CREATE TABLE public.COLLABORATION (
  id             SERIAL   NOT NULL PRIMARY KEY,
  colaborator_id INTEGER  NOT NULL,
  properties_id  INTEGER  NOT NULL,
  mindmap_id     INTEGER  NOT NULL,
  role_id        INTEGER  NOT NULL,
  FOREIGN KEY (colaborator_id) REFERENCES public.COLLABORATOR (id),
  FOREIGN KEY (mindmap_id) REFERENCES public.MINDMAP (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  FOREIGN KEY (properties_id) REFERENCES public.COLLABORATION_PROPERTIES (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  UNIQUE (mindmap_id, colaborator_id)
);

CREATE TABLE public.ACCESS_AUDITORY (
  id         SERIAL   NOT NULL PRIMARY KEY,
  login_date DATE,
  user_id    INTEGER  NOT NULL,
  FOREIGN KEY (user_id) REFERENCES public.USER (colaborator_id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

COMMIT;
