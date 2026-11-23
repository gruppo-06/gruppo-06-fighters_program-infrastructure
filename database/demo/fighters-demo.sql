--
-- PostgreSQL database dump
--

\restrict 0ovVwYwjku37gvkhfkMUzd3eT6ZAUoKQVf29CfdWV4vXONnoEcuH5U05mR3lJwk

-- Dumped from database version 17.12 (Debian 17.12-1.pgdg13+1)
-- Dumped by pg_dump version 17.12 (Debian 17.12-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: app_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_user (
    id bigint NOT NULL,
    nickname character varying(20) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(100) NOT NULL,
    role character varying(10) DEFAULT 'PLAYER'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT app_user_role_check CHECK (((role)::text = ANY ((ARRAY['PLAYER'::character varying, 'ADMIN'::character varying])::text[])))
);


--
-- Name: app_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_user_id_seq OWNED BY public.app_user.id;


--
-- Name: card; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.card (
    id bigint NOT NULL,
    code character varying(10) NOT NULL,
    name character varying(100) NOT NULL,
    country character varying(100),
    faction_id smallint NOT NULL,
    class_id smallint NOT NULL,
    rarity_id smallint NOT NULL,
    atk integer NOT NULL,
    def integer NOT NULL,
    vel integer NOT NULL,
    crt integer NOT NULL,
    flavor_text text,
    image_file character varying(255),
    active boolean DEFAULT true NOT NULL,
    admin_managed boolean DEFAULT false NOT NULL,
    CONSTRAINT card_atk_check CHECK (((atk >= 0) AND (atk <= 1000))),
    CONSTRAINT card_crt_check CHECK (((crt >= 0) AND (crt <= 1000))),
    CONSTRAINT card_def_check CHECK (((def >= 0) AND (def <= 1000))),
    CONSTRAINT card_vel_check CHECK (((vel >= 0) AND (vel <= 1000)))
);


--
-- Name: card_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.card_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.card_id_seq OWNED BY public.card.id;


--
-- Name: credit_transaction; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.credit_transaction (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    amount integer NOT NULL,
    type character varying(20) NOT NULL,
    reference character varying(255),
    idempotency_key character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT credit_transaction_amount_check CHECK ((amount <> 0)),
    CONSTRAINT credit_transaction_type_check CHECK (((type)::text = ANY ((ARRAY['WELCOME'::character varying, 'DAILY'::character varying, 'MATCH_WIN'::character varying, 'PACK_PURCHASE'::character varying, 'ADMIN_GRANT'::character varying, 'SKIN_PURCHASE'::character varying, 'TROPHY'::character varying, 'DAILY_CHALLENGE'::character varying, 'BATTLE_PASS'::character varying])::text[])))
);


--
-- Name: credit_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.credit_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credit_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.credit_transaction_id_seq OWNED BY public.credit_transaction.id;


--
-- Name: daily_claim; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daily_claim (
    user_id bigint NOT NULL,
    last_claim_date date NOT NULL,
    streak integer NOT NULL,
    CONSTRAINT daily_claim_streak_check CHECK ((streak >= 1))
);


--
-- Name: deck; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deck (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    name character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: deck_card; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deck_card (
    deck_id bigint NOT NULL,
    card_id bigint NOT NULL,
    copies integer NOT NULL,
    CONSTRAINT deck_card_copies_check CHECK ((copies >= 1))
);


--
-- Name: deck_card_subcard; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deck_card_subcard (
    deck_id bigint NOT NULL,
    card_id bigint NOT NULL,
    subcard_id smallint NOT NULL
);


--
-- Name: deck_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deck_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deck_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deck_id_seq OWNED BY public.deck.id;


--
-- Name: faction; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.faction (
    id smallint NOT NULL,
    name character varying(50) NOT NULL
);


--
-- Name: fighter_class; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fighter_class (
    id smallint NOT NULL,
    name character varying(50) NOT NULL
);


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


--
-- Name: friendship; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friendship (
    id bigint NOT NULL,
    requester_id bigint NOT NULL,
    addressee_id bigint NOT NULL,
    status character varying(10) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    accepted_at timestamp with time zone,
    CONSTRAINT friendship_check CHECK ((requester_id <> addressee_id)),
    CONSTRAINT friendship_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'ACCEPTED'::character varying])::text[])))
);


--
-- Name: friendship_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.friendship_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendship_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.friendship_id_seq OWNED BY public.friendship.id;


--
-- Name: match; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.match (
    id bigint NOT NULL,
    challenger_id bigint NOT NULL,
    opponent_id bigint NOT NULL,
    challenger_deck_id bigint,
    opponent_deck_id bigint,
    status character varying(10) DEFAULT 'PENDING'::character varying NOT NULL,
    winner_id bigint,
    seed bigint,
    log jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    finished_at timestamp with time zone,
    challenger_deck_snapshot jsonb,
    opponent_deck_snapshot jsonb,
    mode character varying(10) DEFAULT 'BASE'::character varying NOT NULL,
    CONSTRAINT match_check CHECK ((challenger_id <> opponent_id)),
    CONSTRAINT match_check1 CHECK (((winner_id IS NULL) OR ((winner_id = challenger_id) OR (winner_id = opponent_id)))),
    CONSTRAINT match_check2 CHECK ((((status)::text <> 'FINISHED'::text) OR (finished_at IS NOT NULL))),
    CONSTRAINT match_mode_check CHECK (((mode)::text = ANY ((ARRAY['BASE'::character varying, 'ADVANCED'::character varying])::text[]))),
    CONSTRAINT match_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'FINISHED'::character varying, 'DECLINED'::character varying, 'CANCELLED'::character varying])::text[])))
);


--
-- Name: match_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.match_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.match_id_seq OWNED BY public.match.id;


--
-- Name: pack; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pack (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(255),
    price integer NOT NULL,
    active boolean DEFAULT true NOT NULL,
    CONSTRAINT pack_price_check CHECK ((price >= 0))
);


--
-- Name: pack_content; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pack_content (
    pack_id bigint NOT NULL,
    rarity_id smallint NOT NULL,
    card_count integer NOT NULL,
    CONSTRAINT pack_content_card_count_check CHECK ((card_count >= 1))
);


--
-- Name: pack_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pack_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pack_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pack_id_seq OWNED BY public.pack.id;


--
-- Name: pack_opening; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pack_opening (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    pack_id bigint NOT NULL,
    cards jsonb NOT NULL,
    idempotency_key character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: pack_opening_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pack_opening_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pack_opening_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pack_opening_id_seq OWNED BY public.pack_opening.id;


--
-- Name: rarity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rarity (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    rank smallint NOT NULL
);


--
-- Name: subcard; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subcard (
    id smallint NOT NULL,
    code character varying(10) NOT NULL,
    name character varying(60) NOT NULL,
    description character varying(255),
    atk_percent smallint DEFAULT 0 NOT NULL,
    def_percent smallint DEFAULT 0 NOT NULL,
    vel_percent smallint DEFAULT 0 NOT NULL,
    crt_percent smallint DEFAULT 0 NOT NULL,
    CONSTRAINT subcard_atk_percent_check CHECK (((atk_percent >= '-50'::integer) AND (atk_percent <= 50))),
    CONSTRAINT subcard_crt_percent_check CHECK (((crt_percent >= '-50'::integer) AND (crt_percent <= 50))),
    CONSTRAINT subcard_def_percent_check CHECK (((def_percent >= '-50'::integer) AND (def_percent <= 50))),
    CONSTRAINT subcard_vel_percent_check CHECK (((vel_percent >= '-50'::integer) AND (vel_percent <= 50)))
);


--
-- Name: subcard_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subcard_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subcard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subcard_id_seq OWNED BY public.subcard.id;


--
-- Name: trade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trade (
    id bigint NOT NULL,
    sender_id bigint NOT NULL,
    recipient_id bigint NOT NULL,
    status character varying(10) DEFAULT 'PENDING'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    resolved_at timestamp with time zone,
    CONSTRAINT trade_check CHECK ((sender_id <> recipient_id)),
    CONSTRAINT trade_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'ACCEPTED'::character varying, 'DECLINED'::character varying, 'CANCELLED'::character varying])::text[])))
);


--
-- Name: trade_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trade_id_seq OWNED BY public.trade.id;


--
-- Name: trade_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trade_item (
    trade_id bigint NOT NULL,
    card_id bigint NOT NULL,
    quantity integer NOT NULL,
    side character varying(10) NOT NULL,
    CONSTRAINT trade_item_quantity_check CHECK ((quantity >= 1)),
    CONSTRAINT trade_item_side_check CHECK (((side)::text = ANY ((ARRAY['OFFERED'::character varying, 'REQUESTED'::character varying])::text[])))
);


--
-- Name: user_card; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_card (
    user_id bigint NOT NULL,
    card_id bigint NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT user_card_quantity_check CHECK ((quantity >= 1))
);


--
-- Name: app_user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user ALTER COLUMN id SET DEFAULT nextval('public.app_user_id_seq'::regclass);


--
-- Name: card id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.card ALTER COLUMN id SET DEFAULT nextval('public.card_id_seq'::regclass);


--
-- Name: credit_transaction id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credit_transaction ALTER COLUMN id SET DEFAULT nextval('public.credit_transaction_id_seq'::regclass);


--
-- Name: deck id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deck ALTER COLUMN id SET DEFAULT nextval('public.deck_id_seq'::regclass);


--
-- Name: friendship id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendship ALTER COLUMN id SET DEFAULT nextval('public.friendship_id_seq'::regclass);


--
-- Name: match id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match ALTER COLUMN id SET DEFAULT nextval('public.match_id_seq'::regclass);


--
-- Name: pack id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pack ALTER COLUMN id SET DEFAULT nextval('public.pack_id_seq'::regclass);


--
-- Name: pack_opening id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pack_opening ALTER COLUMN id SET DEFAULT nextval('public.pack_opening_id_seq'::regclass);


--
-- Name: subcard id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcard ALTER COLUMN id SET DEFAULT nextval('public.subcard_id_seq'::regclass);


--
-- Name: trade id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trade ALTER COLUMN id SET DEFAULT nextval('public.trade_id_seq'::regclass);


--
-- Data for Name: app_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_user (id, nickname, email, password_hash, role, created_at) FROM stdin;
1	sara	sara@fighters.demo	$2a$10$Ptu8fxalEo8s.PtPKqlQT.tPOWldt3ITEu8V.af9tGiqjAkGEBMBK	PLAYER	2026-11-23 10:41:16.589008+00
2	marco	marco@fighters.demo	$2a$10$3FTLea9ztwis.PL9z9AwnubGAYGj..KoKXp0voFGiBR3d7NKqyxmC	PLAYER	2026-11-23 10:41:17.232639+00
3	giulia	giulia@fighters.demo	$2a$10$VX8J6/90E7vC.Q4ubHuHfOP76JcyYeiZmvyybBYxtk4UPTVZDjQN6	PLAYER	2026-11-23 10:41:17.586846+00
4	luca	luca@fighters.demo	$2a$10$l.gjoqVOGLZHvd4.ZtYwUeYnzjtnrl3/StHck0DUVx670GJQ2Ue..	PLAYER	2026-11-23 10:41:17.92418+00
\.


--
-- Data for Name: card; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.card (id, code, name, country, faction_id, class_id, rarity_id, atk, def, vel, crt, flavor_text, image_file, active, admin_managed) FROM stdin;
1	AF01	Musa Bello	Nigeria	3	1	3	250	692	550	550	Musa è cresciuto in una famiglia di combattenti tradizionali, partecipando fin da giovane a competizioni locali.	AF01.webp	t	f
2	AF02	Tiana Rabe	Madagascar	3	1	2	245	652	550	550	Grazie alla sua agilità è diventata rapidamente una combattente molto popolare.	AF02.webp	t	f
3	AF03	Kito Manuel	Angola	3	1	1	230	638	550	550	Kito ha accettato perché desidera conoscere altre forme di combattimento e migliorare ulteriormente la propria tecnica.	AF03.webp	t	f
4	AF04	Ines Mansour	Tunisia	3	1	1	235	625	550	550	Ines è una campionessa professionista che ha dedicato tutta la propria vita alla competizione sportiva.	AF04.webp	t	f
5	AF05	Yassin Amrani	Marocco	3	2	3	263	535	850	400	Yassin è cresciuto nei quartieri storici di Fès, dove ha iniziato a lavorare come ladro e contrabbandiere.	AF05.webp	t	f
6	AF06	Aya Koné	Costa d'Avorio	3	2	2	265	490	850	400	Aya era una specialista nella sicurezza informatica di una grande corporazione con sede ad Abidjan.	AF06.webp	t	f
7	AF07	Nadir Belkacem	Algeria	3	2	1	242	495	850	400	Nadir è un ex operatore di sicurezza specializzato nella protezione di installazioni energetiche nel Sahara.	AF07.webp	t	f
8	AF08	Salma Nasser	Egitto	3	3	3	203	863	500	850	Salma è una fisica specializzata nello sviluppo di nuove tecnologie militari.	AF08.webp	t	f
9	AF09	Paulo Mussa	Mozambico	3	3	2	193	830	500	900	Paulo lavorava come tecnico specializzato nella manutenzione di grandi infrastrutture portuali.	AF09.webp	t	f
10	AF10	Jacob Maseko	Sudafrica	3	4	2	318	680	250	650	Jacob è stato successivamente invitato al torneo come rappresentante dei nuovi sistemi di potenziamento meccanico.	AF10.webp	t	f
11	AF11	Ama Mensah	Ghana	3	4	4	340	734	250	700	Ama è una donna dalla corporatura eccezionalmente robusta, dotata di una forza naturale molto superiore alla media.	AF11.webp	t	f
12	AF12	Nia Kamau	Kenya	3	4	1	312	632	250	700	Nia è cresciuta in una famiglia di atleti, sviluppando fin da giovane una statura eccezionale e una forza superiore alla media.	AF12.webp	t	f
13	AF13	Malia Kanku	Repubblica Democratica del Congo	3	4	1	306	646	250	700	Malia lavorava come operatrice logistica in una grande struttura industriale.	AF13.webp	t	f
14	AF14	Malick Diop	Senegal	3	4	1	296	666	250	700	Malick è nato in una famiglia di lottatori, mostrando fin dall'infanzia una crescita fisica fuori dal comune.	AF14.webp	t	f
15	AF15	Neema Mushi	Tanzania	3	5	1	202	882	400	450	Neema lavorava come ranger in una grande riserva naturale della Tanzania.	AF15.webp	t	f
16	AF16	Dawit Bekele	Etiopia	3	5	1	205	864	400	475	Dopo aver abbandonato le competizioni, ha iniziato a insegnare ai giovani della propria regione.	AF16.webp	t	f
17	EU01	Marta Kowalska	Polonia	2	1	3	242	712	550	550	Nonostante le offerte ricevute, ha sempre rifiutato qualsiasi potenziamento, convinta che la vera abilità derivi dall'allenamento.	EU01.webp	t	f
18	EU02	Arman Farhadi	Iran	2	1	2	238	665	550	600	Arman ha accettato per dimostrare che il valore di un combattente non può essere misurato soltanto attraverso le sue capacità fisiche.	EU02.webp	t	f
19	EU03	Nino Beridze	Georgia	2	2	3	278	505	850	400	Nino proviene da una famiglia che tramanda da generazioni le arti marziali georgiane.	EU03.webp	t	f
20	EU04	Samir Haddad	Giordania	2	2	2	263	500	850	350	Samir lavorava come guida e responsabile della sicurezza per convogli commerciali che attraversavano le zone desertiche del Medio Oriente.	EU04.webp	t	f
21	EU05	Lev Morozov	Russia	2	3	4	211	896	500	850	Lev è un operatore militare conosciuto per la sua capacità di completare incarichi estremamente pericolosi senza mostrare alcuna emozione.	EU05.webp	t	f
22	EU06	Anahit Sarkisyan	Armenia	2	3	3	209	838	500	850	Anahit è un'ex operatrice di una squadra specializzata nel recupero di persone scomparse nelle regioni montuose dell'Armenia.	EU06.webp	t	f
23	EU07	Bekzod Karimov	Uzbekistan	2	3	2	191	847	500	850	Bekzod è cresciuto in una piccola comunità dell'Uzbekistan, sviluppando fin da giovane una straordinaria capacità di concentrazione.	EU07.webp	t	f
24	EU08	Leyla Mammadova	Azerbaigian	2	3	1	191	780	500	850	Leyla è un'ex ingegnera elettronica che lavorava per una corporazione impegnata nello sviluppo di tecnologie energetiche nel Mar Caspio.	EU08.webp	t	f
25	EU09	Iryna Koval	Ucraina	2	3	1	193	772	500	850	Iryna è un'ex operatrice militare specializzata nella gestione di sistemi senza pilota.	EU09.webp	t	f
26	EU10	Vera Sokolova	Russia	2	4	2	321	666	250	700	Vera lavorava come operatrice di macchinari industriali in una grande struttura estrattiva.	EU10.webp	t	f
27	EU11	Nurlan Saparov	Kazakistan	2	4	1	301	653	250	725	Nurlan proviene da una famiglia di lottatori e ha dedicato la propria vita alla pratica del Qazaq Kuresi.	EU11.webp	t	f
28	EU12	Baran Aksoy	Turchia	2	4	1	302	653	250	700	Baran è un celebre lottatore turco, conosciuto per la sua straordinaria forza e per la capacità di sfuggire anche alle prese più difficili.	EU12.webp	t	f
29	EU13	Aram Vardanyan	Armenia	2	5	1	200	891	400	450	Aram è un ex soccorritore specializzato nelle operazioni in montagna.	EU13.webp	t	f
30	EU14	Oksana Hrytsenko	Ucraina	2	5	1	204	873	400	450	Oksana accetta, sperando che i risultati delle sperimentazioni possano migliorare la sicurezza delle future squadre di soccorso.	EU14.webp	t	f
31	EU15	Aizada Bekova	Kirghizistan	2	5	1	211	846	400	450	Aizada è un'ex campionessa di Alysh, cresciuta nelle regioni montuose del Kirghizistan.	EU15.webp	t	f
32	EU16	Radu Ionescu	Romania	2	5	1	213	837	400	450	Radu lavorava come responsabile della sicurezza di alcune infrastrutture sotterranee nei Carpazi.	EU16.webp	t	f
33	EA01	Daichi Arata	Giappone	1	1	3	257	672	550	550	Discendente di una famiglia di maestri di karate, Daichi considera il combattimento una forma di perfezionamento spirituale.	EA01.webp	t	f
34	EA02	Nico Valenti	Italia	1	1	2	235	678	550	550	Nato in un quartiere popolare di Torino, Nico è un giovane kickboxer che sogna di diventare famoso.	EA02.webp	t	f
35	EA03	Ren Saito	Giappone	1	2	4	281	540	850	400	Ren appartiene a un'antica famiglia di samurai che ha continuato a tramandare le proprie tradizioni anche nell'era delle megacorporazioni.	EA03.webp	t	f
36	EA04	Adrian Sterling	Regno Unito	1	2	3	270	520	850	400	Un tempo agente di un servizio d'intelligence britannico, Adrian è diventato una spia privata per le più importanti corporazioni del mondo.	EA04.webp	t	f
37	EA05	Luc Moreau	Francia	1	2	2	257	500	850	450	Luc è un ex agente operativo di una corporazione specializzata in armamenti sperimentali.	EA05.webp	t	f
38	EA06	Seo Yuna	Corea del Sud	1	2	1	247	485	850	400	Yuna è cresciuta in una famiglia che custodisce antiche tecniche marziali coreane.	EA06.webp	t	f
39	EA07	Tiago Vale	Portogallo	1	2	1	250	480	850	400	Tiago è cresciuto nei quartieri portuali di Lisbona, sopravvivendo attraverso contrabbando e lavori per organizzazioni criminali.	EA07.webp	t	f
40	EA08	Mason Cole	Stati Uniti	1	3	3	197	888	500	850	Mason è un ex militare che, dopo una missione disastrosa, ha deciso di lavorare per una compagnia di sicurezza privata.	EA08.webp	t	f
41	EA09	Lena Vogel	Germania	1	3	2	199	813	500	850	Lena è un'ingegnera specializzata nello sviluppo di armi avanzate.	EA09.webp	t	f
42	EA10	Erik Nyström	Svezia	1	3	1	189	789	500	850	Erik era un operatore specializzato nella sorveglianza di installazioni militari nell'Europa settentrionale.	EA10.webp	t	f
43	EA11	Tara Quinn	Australia	1	3	1	181	822	500	850	Tara è un'ex operatrice delle forze speciali, esperta di missioni nei territori desertici australiani.	EA11.webp	t	f
44	EA12	Noah Bouchard	Canada	1	4	2	312	680	250	750	Noah lavorava come minatore nel Québec.	EA12.webp	t	f
45	EA13	Darius King	Stati Uniti	1	4	1	309	639	250	700	Darius era una superstar del wrestling, celebre per la propria forza e per le spettacolari mosse eseguite sul ring.	EA13.webp	t	f
46	EA14	Aino Korhonen	Finlandia	1	5	1	209	855	400	450	Aino è una veterana delle operazioni di soccorso nelle regioni artiche.	EA14.webp	t	f
47	EA15	Maia Rangi	Nuova Zelanda	1	5	1	206	864	400	450	Maia lavorava nelle squadre di risposta alle catastrofi naturali, specializzandosi nel recupero di persone intrappolate in edifici crollati.	EA15.webp	t	f
48	EA16	Evelyn Brooks	Canada	1	5	1	202	882	400	450	Evelyn è un'ex guardia del corpo corporativa, specializzata nella protezione di dirigenti e ricercatori.	EA16.webp	t	f
49	IP01	Amar Nair	India	5	1	3	250	692	550	550	Amar partecipa al torneo per comprendere fino a che punto il suo nuovo corpo possa spingersi, senza perdere la propria serenità interiore.	IP01.webp	t	f
50	IP02	Lin Yue	Cina	5	1	2	242	665	550	500	Quando una corporazione ha annunciato un torneo aperto anche agli artisti marziali tradizionali, Lin ha deciso di partecipare personalmente.	IP02.webp	t	f
51	IP03	Mai Tran	Vietnam	5	1	1	226	652	550	550	Determinata a dimostrare il contrario, Mai ha deciso di partecipare al torneo internazionale.	IP03.webp	t	f
52	IP04	Rafael Cruz	Filippine	5	2	3	263	535	850	400	Partecipa al torneo perché gli è stata promessa la cancellazione del debito in caso di vittoria.	IP04.webp	t	f
53	IP05	Nur Aisyah	Malesia	5	2	2	255	510	850	400	Nur è stata addestrata fin dall'infanzia da una famiglia che tramanda antiche tecniche di Silat.	IP05.webp	t	f
54	IP06	Chen Mei	Taiwan	5	3	3	203	863	500	850	Chen sa di essere seguita, ma non conosce ancora l'identità della propria inseguitrice.	IP06.webp	t	f
55	IP07	Farid Khan	Pakistan	5	3	2	197	830	500	800	Farid è un ex operatore militare specializzato nelle missioni ad alta quota nelle regioni del Karakorum.	IP07.webp	t	f
56	IP08	Batsaikhan Dorj	Mongolia	5	4	2	309	694	250	700	Dopo aver vinto numerose competizioni, è stato avvicinato da una corporazione interessata alla sua forza naturale.	IP08.webp	t	f
57	IP09	Kiet Suriya	Thailandia	5	4	1	293	673	250	700	La sua altezza e la sua forza sono naturali, ma un grave infortunio lo ha costretto a interrompere temporaneamente la carriera.	IP09.webp	t	f
58	IP10	Sari Wibowo	Indonesia	5	4	1	299	660	250	700	Sari lavorava come operatrice specializzata in una gigantesca miniera geotermica.	IP10.webp	t	f
59	IP11	Mere Tawake	Figi	5	4	1	312	632	250	700	Dopo un devastante ciclone che ha distrutto parte della sua comunità, ha iniziato a organizzare operazioni di recupero e ricostruzione.	IP11.webp	t	f
60	IP12	Tenzin Gurung	Nepal	5	5	1	205	864	400	475	Tenzin è una guida alpina esperta, cresciuta nelle regioni himalayane del Nepal.	IP12.webp	t	f
61	IP13	Farzana Rahman	Bangladesh	5	5	1	200	891	400	450	Farzana è un'ingegnera specializzata nello sviluppo di strutture e dispositivi per la protezione dalle inondazioni.	IP13.webp	t	f
62	IP14	Nadeesha Perera	Sri Lanka	5	5	1	204	873	400	450	Nadeesha è un'ex istruttrice di arti marziali che ha dedicato gran parte della propria vita all'insegnamento.	IP14.webp	t	f
63	IP15	Khamla Vong	Laos	5	5	4	232	972	400	450	Khamla è un ricercatore specializzato nello sviluppo di materiali biologici capaci di adattarsi alle condizioni ambientali.	IP15.webp	t	f
64	IP16	Dara Sok	Cambogia	5	5	1	211	846	400	450	Dara è cresciuto in una famiglia di istruttori di arti marziali tradizionali.	IP16.webp	t	f
65	PA01	Lucas Ferreira	Brasile	4	1	3	242	712	550	550	Lucas è cresciuto a Salvador, in Brasile, dove ha iniziato a praticare la Capoeira fin da bambino.	PA01.webp	t	f
66	PA02	Camila Reyes	Cuba	4	1	2	245	652	550	550	Camila è una giovane pugile cubana cresciuta in una famiglia di atleti.	PA02.webp	t	f
67	PA03	Diego Solís	Messico	4	1	1	229	638	550	575	Il suo stile spettacolare e il suo atteggiamento teatrale gli hanno permesso di conquistare un enorme seguito di appassionati.	PA03.webp	t	f
68	PA04	Tomás Valencia	Colombia	4	1	1	223	658	550	550	Tomás è un maestro di arti marziali originario della regione del Cauca.	PA04.webp	t	f
69	PA05	Valentina Rojas	Argentina	4	1	4	259	718	550	550	Valentina ha accettato, recuperando completamente le proprie capacità fisiche.	PA05.webp	t	f
70	PA06	Jean Baptiste	Haiti	4	2	3	278	505	850	400	Jean sfrutta soprattutto la precisione tecnica e il controllo della distanza, evitando movimenti inutili.	PA06.webp	t	f
71	PA07	Elena Cárdenas	Ecuador	4	2	2	265	490	850	400	Elena lavorava come guida alpina e specialista nel recupero di persone disperse sulle Ande.	PA07.webp	t	f
72	PA08	Ixchel Morales	Guatemala	4	2	1	257	465	850	400	Partecipa al torneo con l'obiettivo di individuare i responsabili del programma e recuperare ulteriori prove.	PA08.webp	t	f
73	PA09	Bruno Acosta	Uruguay	4	2	1	252	475	850	400	Bruno è un ex impiegato finanziario che lavorava per una potente corporazione internazionale.	PA09.webp	t	f
74	PA10	Gabriel Ortega	Panama	4	3	3	209	838	500	850	Gabriel lavorava come tecnico specializzato nella manutenzione delle grandi infrastrutture del Canale di Panama.	PA10.webp	t	f
75	PA11	Daniela Fuentes	Cile	4	3	2	193	830	500	900	Daniela è un'ingegnera mineraria che ha trascorso gran parte della propria carriera nelle gigantesche miniere del deserto di Atacama.	PA11.webp	t	f
76	PA12	Sofia Vargas	Costa Rica	4	3	1	185	805	500	850	Sofia è una ricercatrice specializzata nello sviluppo di materiali biologici destinati alla protezione degli ecosistemi tropicali.	PA12.webp	t	f
77	PA13	Beatriz Costa	Brasile	4	4	2	318	680	250	650	Beatriz è un'ex campionessa di Jiu-Jitsu brasiliano conosciuta per la propria corporatura eccezionalmente robusta.	PA13.webp	t	f
78	PA14	Héctor Castillo	Repubblica Dominicana	4	4	1	306	646	250	700	Héctor è un ex giocatore professionista di baseball, celebre per la straordinaria potenza dei suoi colpi.	PA14.webp	t	f
79	PA15	Lucía Quispe	Perù	4	5	1	213	837	400	450	Lucía ha accettato per ottenere i finanziamenti necessari a migliorare i sistemi di sicurezza delle comunità montane.	PA15.webp	t	f
80	PA16	Marcus Reid	Giamaica	4	5	1	209	855	400	450	Marcus è un ex tecnico del suono che ha lavorato per anni nella manutenzione di grandi impianti audio e sistemi di comunicazione.	PA16.webp	t	f
\.


--
-- Data for Name: credit_transaction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.credit_transaction (id, user_id, amount, type, reference, idempotency_key, created_at) FROM stdin;
1	1	500	WELCOME	Welcome bonus	welcome:1	2026-11-23 10:41:16.834992+00
2	2	500	WELCOME	Welcome bonus	welcome:2	2026-11-23 10:41:17.418447+00
3	3	500	WELCOME	Welcome bonus	welcome:3	2026-11-23 10:41:17.754823+00
4	4	500	WELCOME	Welcome bonus	welcome:4	2026-11-23 10:41:18.092975+00
5	1	50	MATCH_WIN	Match 1 won	match-win:1	2026-11-23 10:41:18.419053+00
6	1	50	MATCH_WIN	Match 2 won	match-win:2	2026-11-23 10:41:18.508996+00
7	3	50	MATCH_WIN	Match 3 won	match-win:3	2026-11-23 10:41:18.583836+00
\.


--
-- Data for Name: daily_claim; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.daily_claim (user_id, last_claim_date, streak) FROM stdin;
\.


--
-- Data for Name: deck; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.deck (id, user_id, name, created_at) FROM stdin;
1	1	Furia del Sud	2026-11-23 10:41:17.160899+00
2	2	Muro d'Acciaio	2026-11-23 10:41:17.563553+00
3	3	Vento dell'Ovest	2026-11-23 10:41:17.898518+00
4	4	Lama d'Oriente	2026-11-23 10:41:18.227963+00
\.


--
-- Data for Name: deck_card; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.deck_card (deck_id, card_id, copies) FROM stdin;
1	2	1
1	6	1
1	3	1
1	4	1
1	7	1
1	12	1
1	13	1
1	14	1
1	15	1
1	16	1
2	18	1
2	20	1
2	24	1
2	25	1
2	27	1
2	28	1
2	29	1
2	30	1
2	31	1
2	32	1
3	66	1
3	71	1
3	67	1
3	68	1
3	72	1
3	73	1
3	76	1
3	78	1
3	79	1
3	80	1
4	34	1
4	37	1
4	38	1
4	39	1
4	42	1
4	43	1
4	45	1
4	46	1
4	47	1
4	48	1
\.


--
-- Data for Name: deck_card_subcard; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.deck_card_subcard (deck_id, card_id, subcard_id) FROM stdin;
1	2	1
1	2	7
1	6	5
1	6	6
1	3	1
1	3	7
1	3	11
1	4	1
1	4	7
1	4	11
1	7	5
1	7	6
1	7	11
1	12	4
1	12	5
1	12	11
1	13	4
1	13	5
1	13	11
1	14	4
1	14	5
1	14	11
1	15	1
1	15	2
1	15	7
1	16	1
1	16	2
1	16	7
2	18	6
2	18	9
2	20	4
2	20	3
2	24	8
2	24	4
2	24	12
2	25	8
2	25	4
2	25	12
2	27	8
2	27	1
2	27	12
2	28	8
2	28	1
2	28	12
2	29	2
2	29	6
2	29	9
2	30	2
2	30	6
2	30	9
2	31	2
2	31	6
2	31	9
2	32	2
2	32	6
2	32	9
3	66	1
3	66	7
3	71	5
3	71	6
3	67	1
3	67	7
3	67	11
3	68	1
3	68	7
3	68	11
3	72	5
3	72	6
3	72	11
3	73	5
3	73	6
3	73	11
3	76	3
3	76	9
3	76	11
3	78	4
3	78	5
3	78	11
3	79	1
3	79	2
3	79	7
3	80	1
3	80	2
3	80	7
4	34	6
4	34	9
4	37	4
4	37	3
4	38	4
4	38	3
4	38	10
4	39	4
4	39	3
4	39	10
4	42	8
4	42	4
4	42	12
4	43	8
4	43	4
4	43	12
4	45	8
4	45	1
4	45	12
4	46	2
4	46	6
4	46	9
4	47	2
4	47	6
4	47	9
4	48	2
4	48	6
4	48	9
\.


--
-- Data for Name: faction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.faction (id, name) FROM stdin;
1	Euroatlantica
2	Eurasiatica
3	Africana
4	Panamericana
5	Indo-Pacifica
\.


--
-- Data for Name: fighter_class; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fighter_class (id, name) FROM stdin;
1	Combattenti
2	Assassini
3	Specialisti
4	Colossi
5	Sentinelle
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	reference tables	SQL	V1__reference_tables.sql	-402451243	fighters	2026-11-23 11:41:08.615832	10	t
2	2	user and card	SQL	V2__user_and_card.sql	-553349937	fighters	2026-11-23 11:41:08.647809	9	t
3	3	collection and deck	SQL	V3__collection_and_deck.sql	1130988415	fighters	2026-11-23 11:41:08.669997	8	t
4	4	match and trade	SQL	V4__match_and_trade.sql	463446205	fighters	2026-11-23 11:41:08.690114	11	t
5	5	keep matches when a deck is deleted	SQL	V5__keep_matches_when_a_deck_is_deleted.sql	1037999658	fighters	2026-11-23 11:41:08.715139	6	t
6	6	card admin flags	SQL	V6__card_admin_flags.sql	1861161005	fighters	2026-11-23 11:41:08.732362	3	t
7	7	credit ledger	SQL	V7__credit_ledger.sql	-1398654405	fighters	2026-11-23 11:41:08.745582	6	t
8	8	packs	SQL	V8__packs.sql	-1740277726	fighters	2026-11-23 11:41:08.762835	7	t
9	9	seed packs	SQL	V9__seed_packs.sql	2057208892	fighters	2026-11-23 11:41:08.780459	4	t
10	10	daily claim	SQL	V10__daily_claim.sql	1790255431	fighters	2026-11-23 11:41:08.795713	3	t
11	11	match mode	SQL	V11__match_mode.sql	383813427	fighters	2026-11-23 11:41:08.809829	3	t
12	12	subcards	SQL	V12__subcards.sql	1028561044	fighters	2026-11-23 11:41:08.823302	4	t
13	13	deck card subcards	SQL	V13__deck_card_subcards.sql	1394801295	fighters	2026-11-23 11:41:08.837844	3	t
14	14	friendship	SQL	V14__friendship.sql	153439784	fighters	2026-11-23 11:41:08.850865	7	t
\.


--
-- Data for Name: friendship; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.friendship (id, requester_id, addressee_id, status, created_at, accepted_at) FROM stdin;
1	1	2	PENDING	2026-11-23 10:41:18.627173+00	\N
\.


--
-- Data for Name: match; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.match (id, challenger_id, opponent_id, challenger_deck_id, opponent_deck_id, status, winner_id, seed, log, created_at, finished_at, challenger_deck_snapshot, opponent_deck_snapshot, mode) FROM stdin;
1	1	2	1	2	FINISHED	1	1263203024221580767	{"mode": "BASE", "seed": 1263203024221580767, "turns": [{"outcome": "NO_KNOCKOUT", "narration": "Samir Haddad ha il vantaggio di fazione: l'ATK sale da 263 a 276.\\nAya Koné infligge 265 danni a Samir Haddad. Samir Haddad scende a 235 DEF.\\nSamir Haddad infligge 276 danni a Aya Koné. Aya Koné scende a 214 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF06", "cardName": "Aya Koné", "criticalHit": false, "damageDealt": 265, "struckFirst": false, "deckPosition": 0, "defenseAfter": 214, "defenseBefore": 490, "printedAttack": 265, "effectiveAttack": 265, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU04", "cardName": "Samir Haddad", "criticalHit": false, "damageDealt": 276, "struckFirst": false, "deckPosition": 0, "defenseAfter": 235, "defenseBefore": 500, "printedAttack": 263, "effectiveAttack": 276, "hasFactionAdvantage": true}, "turnNumber": 1, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 500, "healthTwoAfter": 500, "replacementOne": null, "replacementTwo": null}, {"outcome": "DOUBLE_KNOCKOUT", "narration": "Samir Haddad ha il vantaggio di fazione: l'ATK sale da 263 a 276.\\nAya Koné infligge 235 danni a Samir Haddad. Samir Haddad scende a 0 DEF.\\nSamir Haddad infligge 214 danni a Aya Koné. Aya Koné scende a 0 DEF.\\nDoppio KO: nessun danno ai punti vita.\\nIl giocatore 1 schiera Nadir Belkacem.\\nIl giocatore 2 schiera Aizada Bekova.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF06", "cardName": "Aya Koné", "criticalHit": false, "damageDealt": 235, "struckFirst": false, "deckPosition": 0, "defenseAfter": 0, "defenseBefore": 214, "printedAttack": 265, "effectiveAttack": 265, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU04", "cardName": "Samir Haddad", "criticalHit": false, "damageDealt": 214, "struckFirst": false, "deckPosition": 0, "defenseAfter": 0, "defenseBefore": 235, "printedAttack": 263, "effectiveAttack": 276, "hasFactionAdvantage": true}, "turnNumber": 1, "roundNumber": 2, "healthDamage": 0, "healthOneAfter": 500, "healthTwoAfter": 500, "replacementOne": {"code": "AF07", "name": "Nadir Belkacem", "deckPosition": 1}, "replacementTwo": {"code": "EU15", "name": "Aizada Bekova", "deckPosition": 1}}, {"outcome": "NO_KNOCKOUT", "narration": "Aizada Bekova ha il vantaggio di fazione: l'ATK sale da 211 a 222.\\nNadir Belkacem infligge 242 danni a Aizada Bekova. Aizada Bekova scende a 604 DEF.\\nAizada Bekova infligge 222 danni a Nadir Belkacem. Nadir Belkacem scende a 273 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF07", "cardName": "Nadir Belkacem", "criticalHit": false, "damageDealt": 242, "struckFirst": false, "deckPosition": 1, "defenseAfter": 273, "defenseBefore": 495, "printedAttack": 242, "effectiveAttack": 242, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU15", "cardName": "Aizada Bekova", "criticalHit": false, "damageDealt": 222, "struckFirst": false, "deckPosition": 1, "defenseAfter": 604, "defenseBefore": 846, "printedAttack": 211, "effectiveAttack": 222, "hasFactionAdvantage": true}, "turnNumber": 2, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 500, "healthTwoAfter": 500, "replacementOne": null, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Aizada Bekova ha il vantaggio di fazione: l'ATK sale da 211 a 222.\\nNadir Belkacem infligge 242 danni a Aizada Bekova. Aizada Bekova scende a 362 DEF.\\nAizada Bekova infligge 222 danni a Nadir Belkacem. Nadir Belkacem scende a 51 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF07", "cardName": "Nadir Belkacem", "criticalHit": false, "damageDealt": 242, "struckFirst": false, "deckPosition": 1, "defenseAfter": 51, "defenseBefore": 273, "printedAttack": 242, "effectiveAttack": 242, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU15", "cardName": "Aizada Bekova", "criticalHit": false, "damageDealt": 222, "struckFirst": false, "deckPosition": 1, "defenseAfter": 362, "defenseBefore": 604, "printedAttack": 211, "effectiveAttack": 222, "hasFactionAdvantage": true}, "turnNumber": 2, "roundNumber": 2, "healthDamage": 0, "healthOneAfter": 500, "healthTwoAfter": 500, "replacementOne": null, "replacementTwo": null}, {"outcome": "FIRST_KNOCKED_OUT", "narration": "Aizada Bekova ha il vantaggio di fazione: l'ATK sale da 211 a 222.\\nNadir Belkacem infligge 242 danni a Aizada Bekova. Aizada Bekova scende a 120 DEF.\\nAizada Bekova infligge 51 danni a Nadir Belkacem. Nadir Belkacem scende a 0 DEF.\\nNadir Belkacem è KO.\\nIl giocatore 1 perde 171 punti vita e scende a 329.\\nIl giocatore 1 schiera Kito Manuel.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF07", "cardName": "Nadir Belkacem", "criticalHit": false, "damageDealt": 242, "struckFirst": false, "deckPosition": 1, "defenseAfter": 0, "defenseBefore": 51, "printedAttack": 242, "effectiveAttack": 242, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU15", "cardName": "Aizada Bekova", "criticalHit": false, "damageDealt": 51, "struckFirst": false, "deckPosition": 1, "defenseAfter": 120, "defenseBefore": 362, "printedAttack": 211, "effectiveAttack": 222, "hasFactionAdvantage": true}, "turnNumber": 2, "roundNumber": 3, "healthDamage": 171, "healthOneAfter": 329, "healthTwoAfter": 500, "replacementOne": {"code": "AF03", "name": "Kito Manuel", "deckPosition": 2}, "replacementTwo": null}, {"outcome": "SECOND_KNOCKED_OUT", "narration": "Aizada Bekova ha il vantaggio di fazione: l'ATK sale da 211 a 222.\\nKito Manuel infligge 120 danni a Aizada Bekova. Aizada Bekova scende a 0 DEF.\\nAizada Bekova infligge 222 danni a Kito Manuel. Kito Manuel scende a 416 DEF.\\nAizada Bekova è KO.\\nIl giocatore 2 perde 110 punti vita e scende a 390.\\nIl giocatore 2 schiera Aram Vardanyan.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF03", "cardName": "Kito Manuel", "criticalHit": false, "damageDealt": 120, "struckFirst": false, "deckPosition": 2, "defenseAfter": 416, "defenseBefore": 638, "printedAttack": 230, "effectiveAttack": 230, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU15", "cardName": "Aizada Bekova", "criticalHit": false, "damageDealt": 222, "struckFirst": false, "deckPosition": 1, "defenseAfter": 0, "defenseBefore": 120, "printedAttack": 211, "effectiveAttack": 222, "hasFactionAdvantage": true}, "turnNumber": 3, "roundNumber": 1, "healthDamage": 110, "healthOneAfter": 329, "healthTwoAfter": 390, "replacementOne": null, "replacementTwo": {"code": "EU13", "name": "Aram Vardanyan", "deckPosition": 2}}, {"outcome": "NO_KNOCKOUT", "narration": "Aram Vardanyan ha il vantaggio di fazione: l'ATK sale da 200 a 210.\\nKito Manuel infligge 230 danni a Aram Vardanyan. Aram Vardanyan scende a 661 DEF.\\nAram Vardanyan infligge 210 danni a Kito Manuel. Kito Manuel scende a 206 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF03", "cardName": "Kito Manuel", "criticalHit": false, "damageDealt": 230, "struckFirst": false, "deckPosition": 2, "defenseAfter": 206, "defenseBefore": 416, "printedAttack": 230, "effectiveAttack": 230, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU13", "cardName": "Aram Vardanyan", "criticalHit": false, "damageDealt": 210, "struckFirst": false, "deckPosition": 2, "defenseAfter": 661, "defenseBefore": 891, "printedAttack": 200, "effectiveAttack": 210, "hasFactionAdvantage": true}, "turnNumber": 4, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 329, "healthTwoAfter": 390, "replacementOne": null, "replacementTwo": null}, {"outcome": "FIRST_KNOCKED_OUT", "narration": "Aram Vardanyan ha il vantaggio di fazione: l'ATK sale da 200 a 210.\\nKito Manuel infligge 230 danni a Aram Vardanyan. Aram Vardanyan scende a 431 DEF.\\nAram Vardanyan infligge 206 danni a Kito Manuel. Kito Manuel scende a 0 DEF.\\nKito Manuel è KO.\\nIl giocatore 1 perde 4 punti vita e scende a 325.\\nIl giocatore 1 schiera Malia Kanku.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF03", "cardName": "Kito Manuel", "criticalHit": false, "damageDealt": 230, "struckFirst": false, "deckPosition": 2, "defenseAfter": 0, "defenseBefore": 206, "printedAttack": 230, "effectiveAttack": 230, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU13", "cardName": "Aram Vardanyan", "criticalHit": false, "damageDealt": 206, "struckFirst": false, "deckPosition": 2, "defenseAfter": 431, "defenseBefore": 661, "printedAttack": 200, "effectiveAttack": 210, "hasFactionAdvantage": true}, "turnNumber": 4, "roundNumber": 2, "healthDamage": 4, "healthOneAfter": 325, "healthTwoAfter": 390, "replacementOne": {"code": "AF13", "name": "Malia Kanku", "deckPosition": 3}, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Aram Vardanyan ha il vantaggio di fazione: l'ATK sale da 200 a 210.\\nMalia Kanku infligge 306 danni a Aram Vardanyan. Aram Vardanyan scende a 125 DEF.\\nAram Vardanyan infligge 210 danni a Malia Kanku. Malia Kanku scende a 436 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF13", "cardName": "Malia Kanku", "criticalHit": false, "damageDealt": 306, "struckFirst": false, "deckPosition": 3, "defenseAfter": 436, "defenseBefore": 646, "printedAttack": 306, "effectiveAttack": 306, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU13", "cardName": "Aram Vardanyan", "criticalHit": false, "damageDealt": 210, "struckFirst": false, "deckPosition": 2, "defenseAfter": 125, "defenseBefore": 431, "printedAttack": 200, "effectiveAttack": 210, "hasFactionAdvantage": true}, "turnNumber": 5, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 325, "healthTwoAfter": 390, "replacementOne": null, "replacementTwo": null}, {"outcome": "SECOND_KNOCKED_OUT", "narration": "Aram Vardanyan ha il vantaggio di fazione: l'ATK sale da 200 a 210.\\nMalia Kanku infligge 125 danni a Aram Vardanyan. Aram Vardanyan scende a 0 DEF.\\nAram Vardanyan infligge 210 danni a Malia Kanku. Malia Kanku scende a 226 DEF.\\nAram Vardanyan è KO.\\nIl giocatore 2 perde 181 punti vita e scende a 209.\\nIl giocatore 2 schiera Baran Aksoy.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF13", "cardName": "Malia Kanku", "criticalHit": false, "damageDealt": 125, "struckFirst": false, "deckPosition": 3, "defenseAfter": 226, "defenseBefore": 436, "printedAttack": 306, "effectiveAttack": 306, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU13", "cardName": "Aram Vardanyan", "criticalHit": false, "damageDealt": 210, "struckFirst": false, "deckPosition": 2, "defenseAfter": 0, "defenseBefore": 125, "printedAttack": 200, "effectiveAttack": 210, "hasFactionAdvantage": true}, "turnNumber": 5, "roundNumber": 2, "healthDamage": 181, "healthOneAfter": 325, "healthTwoAfter": 209, "replacementOne": null, "replacementTwo": {"code": "EU12", "name": "Baran Aksoy", "deckPosition": 3}}, {"outcome": "FIRST_KNOCKED_OUT", "narration": "Baran Aksoy ha il vantaggio di fazione: l'ATK sale da 302 a 317.\\nMalia Kanku infligge 306 danni a Baran Aksoy. Baran Aksoy scende a 347 DEF.\\nBaran Aksoy infligge 226 danni a Malia Kanku. Malia Kanku scende a 0 DEF.\\nMalia Kanku è KO.\\nIl giocatore 1 perde 91 punti vita e scende a 234.\\nIl giocatore 1 schiera Nia Kamau.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF13", "cardName": "Malia Kanku", "criticalHit": false, "damageDealt": 306, "struckFirst": false, "deckPosition": 3, "defenseAfter": 0, "defenseBefore": 226, "printedAttack": 306, "effectiveAttack": 306, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU12", "cardName": "Baran Aksoy", "criticalHit": false, "damageDealt": 226, "struckFirst": false, "deckPosition": 3, "defenseAfter": 347, "defenseBefore": 653, "printedAttack": 302, "effectiveAttack": 317, "hasFactionAdvantage": true}, "turnNumber": 6, "roundNumber": 1, "healthDamage": 91, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": {"code": "AF12", "name": "Nia Kamau", "deckPosition": 4}, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Baran Aksoy ha il vantaggio di fazione: l'ATK sale da 302 a 317.\\nNia Kamau infligge 312 danni a Baran Aksoy. Baran Aksoy scende a 35 DEF.\\nBaran Aksoy infligge 317 danni a Nia Kamau. Nia Kamau scende a 315 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF12", "cardName": "Nia Kamau", "criticalHit": false, "damageDealt": 312, "struckFirst": false, "deckPosition": 4, "defenseAfter": 315, "defenseBefore": 632, "printedAttack": 312, "effectiveAttack": 312, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU12", "cardName": "Baran Aksoy", "criticalHit": false, "damageDealt": 317, "struckFirst": false, "deckPosition": 3, "defenseAfter": 35, "defenseBefore": 347, "printedAttack": 302, "effectiveAttack": 317, "hasFactionAdvantage": true}, "turnNumber": 7, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": null, "replacementTwo": null}, {"outcome": "DOUBLE_KNOCKOUT", "narration": "Baran Aksoy ha il vantaggio di fazione: l'ATK sale da 302 a 317.\\nNia Kamau infligge 35 danni a Baran Aksoy. Baran Aksoy scende a 0 DEF.\\nBaran Aksoy infligge 315 danni a Nia Kamau. Nia Kamau scende a 0 DEF.\\nDoppio KO: nessun danno ai punti vita.\\nIl giocatore 1 schiera Neema Mushi.\\nIl giocatore 2 schiera Arman Farhadi.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF12", "cardName": "Nia Kamau", "criticalHit": false, "damageDealt": 35, "struckFirst": false, "deckPosition": 4, "defenseAfter": 0, "defenseBefore": 315, "printedAttack": 312, "effectiveAttack": 312, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU12", "cardName": "Baran Aksoy", "criticalHit": false, "damageDealt": 315, "struckFirst": false, "deckPosition": 3, "defenseAfter": 0, "defenseBefore": 35, "printedAttack": 302, "effectiveAttack": 317, "hasFactionAdvantage": true}, "turnNumber": 7, "roundNumber": 2, "healthDamage": 0, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": {"code": "AF15", "name": "Neema Mushi", "deckPosition": 5}, "replacementTwo": {"code": "EU02", "name": "Arman Farhadi", "deckPosition": 4}}, {"outcome": "NO_KNOCKOUT", "narration": "Arman Farhadi ha il vantaggio di fazione: l'ATK sale da 238 a 250.\\nNeema Mushi infligge 202 danni a Arman Farhadi. Arman Farhadi scende a 463 DEF.\\nArman Farhadi infligge 250 danni a Neema Mushi. Neema Mushi scende a 632 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF15", "cardName": "Neema Mushi", "criticalHit": false, "damageDealt": 202, "struckFirst": false, "deckPosition": 5, "defenseAfter": 632, "defenseBefore": 882, "printedAttack": 202, "effectiveAttack": 202, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU02", "cardName": "Arman Farhadi", "criticalHit": false, "damageDealt": 250, "struckFirst": false, "deckPosition": 4, "defenseAfter": 463, "defenseBefore": 665, "printedAttack": 238, "effectiveAttack": 250, "hasFactionAdvantage": true}, "turnNumber": 8, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": null, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Arman Farhadi ha il vantaggio di fazione: l'ATK sale da 238 a 250.\\nNeema Mushi infligge 202 danni a Arman Farhadi. Arman Farhadi scende a 261 DEF.\\nArman Farhadi infligge 250 danni a Neema Mushi. Neema Mushi scende a 382 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF15", "cardName": "Neema Mushi", "criticalHit": false, "damageDealt": 202, "struckFirst": false, "deckPosition": 5, "defenseAfter": 382, "defenseBefore": 632, "printedAttack": 202, "effectiveAttack": 202, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU02", "cardName": "Arman Farhadi", "criticalHit": false, "damageDealt": 250, "struckFirst": false, "deckPosition": 4, "defenseAfter": 261, "defenseBefore": 463, "printedAttack": 238, "effectiveAttack": 250, "hasFactionAdvantage": true}, "turnNumber": 8, "roundNumber": 2, "healthDamage": 0, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": null, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Arman Farhadi ha il vantaggio di fazione: l'ATK sale da 238 a 250.\\nNeema Mushi infligge 202 danni a Arman Farhadi. Arman Farhadi scende a 59 DEF.\\nArman Farhadi infligge 250 danni a Neema Mushi. Neema Mushi scende a 132 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF15", "cardName": "Neema Mushi", "criticalHit": false, "damageDealt": 202, "struckFirst": false, "deckPosition": 5, "defenseAfter": 132, "defenseBefore": 382, "printedAttack": 202, "effectiveAttack": 202, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU02", "cardName": "Arman Farhadi", "criticalHit": false, "damageDealt": 250, "struckFirst": false, "deckPosition": 4, "defenseAfter": 59, "defenseBefore": 261, "printedAttack": 238, "effectiveAttack": 250, "hasFactionAdvantage": true}, "turnNumber": 8, "roundNumber": 3, "healthDamage": 0, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": null, "replacementTwo": null}, {"outcome": "DOUBLE_KNOCKOUT", "narration": "Arman Farhadi ha il vantaggio di fazione: l'ATK sale da 238 a 250.\\nNeema Mushi infligge 59 danni a Arman Farhadi. Arman Farhadi scende a 0 DEF.\\nArman Farhadi infligge 132 danni a Neema Mushi. Neema Mushi scende a 0 DEF.\\nDoppio KO: nessun danno ai punti vita.\\nIl giocatore 1 schiera Ines Mansour.\\nIl giocatore 2 schiera Iryna Koval.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF15", "cardName": "Neema Mushi", "criticalHit": false, "damageDealt": 59, "struckFirst": false, "deckPosition": 5, "defenseAfter": 0, "defenseBefore": 132, "printedAttack": 202, "effectiveAttack": 202, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU02", "cardName": "Arman Farhadi", "criticalHit": false, "damageDealt": 132, "struckFirst": false, "deckPosition": 4, "defenseAfter": 0, "defenseBefore": 59, "printedAttack": 238, "effectiveAttack": 250, "hasFactionAdvantage": true}, "turnNumber": 8, "roundNumber": 4, "healthDamage": 0, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": {"code": "AF04", "name": "Ines Mansour", "deckPosition": 6}, "replacementTwo": {"code": "EU09", "name": "Iryna Koval", "deckPosition": 5}}, {"outcome": "NO_KNOCKOUT", "narration": "Iryna Koval ha il vantaggio di fazione: l'ATK sale da 193 a 203.\\nInes Mansour infligge 235 danni a Iryna Koval. Iryna Koval scende a 537 DEF.\\nIryna Koval infligge 203 danni a Ines Mansour. Ines Mansour scende a 422 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF04", "cardName": "Ines Mansour", "criticalHit": false, "damageDealt": 235, "struckFirst": false, "deckPosition": 6, "defenseAfter": 422, "defenseBefore": 625, "printedAttack": 235, "effectiveAttack": 235, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU09", "cardName": "Iryna Koval", "criticalHit": false, "damageDealt": 203, "struckFirst": false, "deckPosition": 5, "defenseAfter": 537, "defenseBefore": 772, "printedAttack": 193, "effectiveAttack": 203, "hasFactionAdvantage": true}, "turnNumber": 9, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": null, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Iryna Koval ha il vantaggio di fazione: l'ATK sale da 193 a 203.\\nInes Mansour infligge 235 danni a Iryna Koval. Iryna Koval scende a 302 DEF.\\nIryna Koval infligge 203 danni a Ines Mansour. Ines Mansour scende a 219 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF04", "cardName": "Ines Mansour", "criticalHit": false, "damageDealt": 235, "struckFirst": false, "deckPosition": 6, "defenseAfter": 219, "defenseBefore": 422, "printedAttack": 235, "effectiveAttack": 235, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU09", "cardName": "Iryna Koval", "criticalHit": false, "damageDealt": 203, "struckFirst": false, "deckPosition": 5, "defenseAfter": 302, "defenseBefore": 537, "printedAttack": 193, "effectiveAttack": 203, "hasFactionAdvantage": true}, "turnNumber": 9, "roundNumber": 2, "healthDamage": 0, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": null, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Iryna Koval ha il vantaggio di fazione: l'ATK sale da 193 a 203.\\nInes Mansour infligge 235 danni a Iryna Koval. Iryna Koval scende a 67 DEF.\\nIryna Koval infligge 203 danni a Ines Mansour. Ines Mansour scende a 16 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF04", "cardName": "Ines Mansour", "criticalHit": false, "damageDealt": 235, "struckFirst": false, "deckPosition": 6, "defenseAfter": 16, "defenseBefore": 219, "printedAttack": 235, "effectiveAttack": 235, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU09", "cardName": "Iryna Koval", "criticalHit": false, "damageDealt": 203, "struckFirst": false, "deckPosition": 5, "defenseAfter": 67, "defenseBefore": 302, "printedAttack": 193, "effectiveAttack": 203, "hasFactionAdvantage": true}, "turnNumber": 9, "roundNumber": 3, "healthDamage": 0, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": null, "replacementTwo": null}, {"outcome": "DOUBLE_KNOCKOUT", "narration": "Iryna Koval ha il vantaggio di fazione: l'ATK sale da 193 a 203.\\nInes Mansour infligge 67 danni a Iryna Koval. Iryna Koval scende a 0 DEF.\\nIryna Koval infligge 16 danni a Ines Mansour. Ines Mansour scende a 0 DEF.\\nDoppio KO: nessun danno ai punti vita.\\nIl giocatore 1 schiera Dawit Bekele.\\nIl giocatore 2 schiera Nurlan Saparov.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF04", "cardName": "Ines Mansour", "criticalHit": false, "damageDealt": 67, "struckFirst": false, "deckPosition": 6, "defenseAfter": 0, "defenseBefore": 16, "printedAttack": 235, "effectiveAttack": 235, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU09", "cardName": "Iryna Koval", "criticalHit": false, "damageDealt": 16, "struckFirst": false, "deckPosition": 5, "defenseAfter": 0, "defenseBefore": 67, "printedAttack": 193, "effectiveAttack": 203, "hasFactionAdvantage": true}, "turnNumber": 9, "roundNumber": 4, "healthDamage": 0, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": {"code": "AF16", "name": "Dawit Bekele", "deckPosition": 7}, "replacementTwo": {"code": "EU11", "name": "Nurlan Saparov", "deckPosition": 6}}, {"outcome": "NO_KNOCKOUT", "narration": "Nurlan Saparov ha il vantaggio di fazione: l'ATK sale da 301 a 316.\\nDawit Bekele infligge 205 danni a Nurlan Saparov. Nurlan Saparov scende a 448 DEF.\\nNurlan Saparov infligge 316 danni a Dawit Bekele. Dawit Bekele scende a 548 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF16", "cardName": "Dawit Bekele", "criticalHit": false, "damageDealt": 205, "struckFirst": false, "deckPosition": 7, "defenseAfter": 548, "defenseBefore": 864, "printedAttack": 205, "effectiveAttack": 205, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU11", "cardName": "Nurlan Saparov", "criticalHit": false, "damageDealt": 316, "struckFirst": false, "deckPosition": 6, "defenseAfter": 448, "defenseBefore": 653, "printedAttack": 301, "effectiveAttack": 316, "hasFactionAdvantage": true}, "turnNumber": 10, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": null, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Nurlan Saparov ha il vantaggio di fazione: l'ATK sale da 301 a 316.\\nDawit Bekele infligge 205 danni a Nurlan Saparov. Nurlan Saparov scende a 243 DEF.\\nNurlan Saparov infligge 316 danni a Dawit Bekele. Dawit Bekele scende a 232 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF16", "cardName": "Dawit Bekele", "criticalHit": false, "damageDealt": 205, "struckFirst": false, "deckPosition": 7, "defenseAfter": 232, "defenseBefore": 548, "printedAttack": 205, "effectiveAttack": 205, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU11", "cardName": "Nurlan Saparov", "criticalHit": false, "damageDealt": 316, "struckFirst": false, "deckPosition": 6, "defenseAfter": 243, "defenseBefore": 448, "printedAttack": 301, "effectiveAttack": 316, "hasFactionAdvantage": true}, "turnNumber": 10, "roundNumber": 2, "healthDamage": 0, "healthOneAfter": 234, "healthTwoAfter": 209, "replacementOne": null, "replacementTwo": null}, {"outcome": "FIRST_KNOCKED_OUT", "narration": "Nurlan Saparov ha il vantaggio di fazione: l'ATK sale da 301 a 316.\\nDawit Bekele infligge 205 danni a Nurlan Saparov. Nurlan Saparov scende a 38 DEF.\\nNurlan Saparov infligge 232 danni a Dawit Bekele. Dawit Bekele scende a 0 DEF.\\nDawit Bekele è KO.\\nIl giocatore 1 perde 84 punti vita e scende a 150.\\nIl giocatore 1 schiera Malick Diop.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF16", "cardName": "Dawit Bekele", "criticalHit": false, "damageDealt": 205, "struckFirst": false, "deckPosition": 7, "defenseAfter": 0, "defenseBefore": 232, "printedAttack": 205, "effectiveAttack": 205, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU11", "cardName": "Nurlan Saparov", "criticalHit": false, "damageDealt": 232, "struckFirst": false, "deckPosition": 6, "defenseAfter": 38, "defenseBefore": 243, "printedAttack": 301, "effectiveAttack": 316, "hasFactionAdvantage": true}, "turnNumber": 10, "roundNumber": 3, "healthDamage": 84, "healthOneAfter": 150, "healthTwoAfter": 209, "replacementOne": {"code": "AF14", "name": "Malick Diop", "deckPosition": 8}, "replacementTwo": null}, {"outcome": "SECOND_KNOCKED_OUT", "narration": "Nurlan Saparov ha il vantaggio di fazione: l'ATK sale da 301 a 316.\\nMalick Diop infligge 38 danni a Nurlan Saparov. Nurlan Saparov scende a 0 DEF.\\nNurlan Saparov infligge 316 danni a Malick Diop. Malick Diop scende a 350 DEF.\\nNurlan Saparov è KO.\\nIl giocatore 2 perde 209 punti vita e scende a 0.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF14", "cardName": "Malick Diop", "criticalHit": false, "damageDealt": 38, "struckFirst": false, "deckPosition": 8, "defenseAfter": 350, "defenseBefore": 666, "printedAttack": 296, "effectiveAttack": 296, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU11", "cardName": "Nurlan Saparov", "criticalHit": false, "damageDealt": 316, "struckFirst": false, "deckPosition": 6, "defenseAfter": 0, "defenseBefore": 38, "printedAttack": 301, "effectiveAttack": 316, "hasFactionAdvantage": true}, "turnNumber": 11, "roundNumber": 1, "healthDamage": 209, "healthOneAfter": 150, "healthTwoAfter": 0, "replacementOne": null, "replacementTwo": null}], "summary": {"cards": [{"player": "ONE", "cardCode": "AF06", "knockouts": 1, "damageDealt": 500, "damageTaken": 490, "deckPosition": 0, "roundsPlayed": 2, "enteredOnTurn": 1}, {"player": "ONE", "cardCode": "AF07", "knockouts": 0, "damageDealt": 726, "damageTaken": 495, "deckPosition": 1, "roundsPlayed": 3, "enteredOnTurn": 2}, {"player": "ONE", "cardCode": "AF03", "knockouts": 1, "damageDealt": 580, "damageTaken": 638, "deckPosition": 2, "roundsPlayed": 3, "enteredOnTurn": 3}, {"player": "ONE", "cardCode": "AF13", "knockouts": 1, "damageDealt": 737, "damageTaken": 646, "deckPosition": 3, "roundsPlayed": 3, "enteredOnTurn": 5}, {"player": "ONE", "cardCode": "AF12", "knockouts": 1, "damageDealt": 347, "damageTaken": 632, "deckPosition": 4, "roundsPlayed": 2, "enteredOnTurn": 7}, {"player": "ONE", "cardCode": "AF15", "knockouts": 1, "damageDealt": 665, "damageTaken": 882, "deckPosition": 5, "roundsPlayed": 4, "enteredOnTurn": 8}, {"player": "ONE", "cardCode": "AF04", "knockouts": 1, "damageDealt": 772, "damageTaken": 625, "deckPosition": 6, "roundsPlayed": 4, "enteredOnTurn": 9}, {"player": "ONE", "cardCode": "AF16", "knockouts": 0, "damageDealt": 615, "damageTaken": 864, "deckPosition": 7, "roundsPlayed": 3, "enteredOnTurn": 10}, {"player": "ONE", "cardCode": "AF14", "knockouts": 1, "damageDealt": 38, "damageTaken": 316, "deckPosition": 8, "roundsPlayed": 1, "enteredOnTurn": 11}, {"player": "TWO", "cardCode": "EU04", "knockouts": 1, "damageDealt": 490, "damageTaken": 500, "deckPosition": 0, "roundsPlayed": 2, "enteredOnTurn": 1}, {"player": "TWO", "cardCode": "EU15", "knockouts": 1, "damageDealt": 717, "damageTaken": 846, "deckPosition": 1, "roundsPlayed": 4, "enteredOnTurn": 2}, {"player": "TWO", "cardCode": "EU13", "knockouts": 1, "damageDealt": 836, "damageTaken": 891, "deckPosition": 2, "roundsPlayed": 4, "enteredOnTurn": 4}, {"player": "TWO", "cardCode": "EU12", "knockouts": 2, "damageDealt": 858, "damageTaken": 653, "deckPosition": 3, "roundsPlayed": 3, "enteredOnTurn": 6}, {"player": "TWO", "cardCode": "EU02", "knockouts": 1, "damageDealt": 882, "damageTaken": 665, "deckPosition": 4, "roundsPlayed": 4, "enteredOnTurn": 8}, {"player": "TWO", "cardCode": "EU09", "knockouts": 1, "damageDealt": 625, "damageTaken": 772, "deckPosition": 5, "roundsPlayed": 4, "enteredOnTurn": 9}, {"player": "TWO", "cardCode": "EU11", "knockouts": 1, "damageDealt": 1180, "damageTaken": 653, "deckPosition": 6, "roundsPlayed": 4, "enteredOnTurn": 10}], "outcome": "PLAYER_ONE_WINS", "endReason": "HEALTH_DEPLETED", "totalTurns": 11}, "deckOneOrder": ["AF06", "AF07", "AF03", "AF13", "AF12", "AF15", "AF04", "AF16", "AF14", "AF02"], "deckTwoOrder": ["EU04", "EU15", "EU13", "EU12", "EU02", "EU09", "EU11", "EU14", "EU16", "EU08"], "rulesVersion": 1}	2026-11-23 10:41:18.272342+00	2026-11-23 10:41:18.376408+00	[{"atk": 245, "crt": 550, "def": 652, "vel": 550, "code": "AF02", "name": "Tiana Rabe", "rarity": "Rara", "faction": "Africana", "subcards": ["SC01", "SC07"]}, {"atk": 265, "crt": 400, "def": 490, "vel": 850, "code": "AF06", "name": "Aya Koné", "rarity": "Rara", "faction": "Africana", "subcards": ["SC05", "SC06"]}, {"atk": 230, "crt": 550, "def": 638, "vel": 550, "code": "AF03", "name": "Kito Manuel", "rarity": "Comune", "faction": "Africana", "subcards": ["SC01", "SC07", "SC11"]}, {"atk": 235, "crt": 550, "def": 625, "vel": 550, "code": "AF04", "name": "Ines Mansour", "rarity": "Comune", "faction": "Africana", "subcards": ["SC01", "SC07", "SC11"]}, {"atk": 242, "crt": 400, "def": 495, "vel": 850, "code": "AF07", "name": "Nadir Belkacem", "rarity": "Comune", "faction": "Africana", "subcards": ["SC05", "SC06", "SC11"]}, {"atk": 312, "crt": 700, "def": 632, "vel": 250, "code": "AF12", "name": "Nia Kamau", "rarity": "Comune", "faction": "Africana", "subcards": ["SC04", "SC05", "SC11"]}, {"atk": 306, "crt": 700, "def": 646, "vel": 250, "code": "AF13", "name": "Malia Kanku", "rarity": "Comune", "faction": "Africana", "subcards": ["SC04", "SC05", "SC11"]}, {"atk": 296, "crt": 700, "def": 666, "vel": 250, "code": "AF14", "name": "Malick Diop", "rarity": "Comune", "faction": "Africana", "subcards": ["SC04", "SC05", "SC11"]}, {"atk": 202, "crt": 450, "def": 882, "vel": 400, "code": "AF15", "name": "Neema Mushi", "rarity": "Comune", "faction": "Africana", "subcards": ["SC01", "SC02", "SC07"]}, {"atk": 205, "crt": 475, "def": 864, "vel": 400, "code": "AF16", "name": "Dawit Bekele", "rarity": "Comune", "faction": "Africana", "subcards": ["SC01", "SC02", "SC07"]}]	[{"atk": 238, "crt": 600, "def": 665, "vel": 550, "code": "EU02", "name": "Arman Farhadi", "rarity": "Rara", "faction": "Eurasiatica", "subcards": ["SC06", "SC09"]}, {"atk": 263, "crt": 350, "def": 500, "vel": 850, "code": "EU04", "name": "Samir Haddad", "rarity": "Rara", "faction": "Eurasiatica", "subcards": ["SC03", "SC04"]}, {"atk": 191, "crt": 850, "def": 780, "vel": 500, "code": "EU08", "name": "Leyla Mammadova", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC04", "SC08", "SC12"]}, {"atk": 193, "crt": 850, "def": 772, "vel": 500, "code": "EU09", "name": "Iryna Koval", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC04", "SC08", "SC12"]}, {"atk": 301, "crt": 725, "def": 653, "vel": 250, "code": "EU11", "name": "Nurlan Saparov", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC01", "SC08", "SC12"]}, {"atk": 302, "crt": 700, "def": 653, "vel": 250, "code": "EU12", "name": "Baran Aksoy", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC01", "SC08", "SC12"]}, {"atk": 200, "crt": 450, "def": 891, "vel": 400, "code": "EU13", "name": "Aram Vardanyan", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC02", "SC06", "SC09"]}, {"atk": 204, "crt": 450, "def": 873, "vel": 400, "code": "EU14", "name": "Oksana Hrytsenko", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC02", "SC06", "SC09"]}, {"atk": 211, "crt": 450, "def": 846, "vel": 400, "code": "EU15", "name": "Aizada Bekova", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC02", "SC06", "SC09"]}, {"atk": 213, "crt": 450, "def": 837, "vel": 400, "code": "EU16", "name": "Radu Ionescu", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC02", "SC06", "SC09"]}]	BASE
2	1	2	1	2	FINISHED	1	6758387203318136081	{"mode": "ADVANCED", "seed": 6758387203318136081, "turns": [{"outcome": "NO_KNOCKOUT", "narration": "Aram Vardanyan ha il vantaggio di fazione: l'ATK sale da 184 a 193.\\nTiana Rabe è più veloce e colpisce per primo.\\nTiana Rabe infligge 275 danni a Aram Vardanyan. Aram Vardanyan scende a 725 DEF.\\nTiana Rabe schiva il colpo di Aram Vardanyan!", "fighterOne": {"dodged": true, "faction": "AFRICAN", "cardCode": "AF02", "cardName": "Tiana Rabe", "criticalHit": false, "damageDealt": 275, "struckFirst": true, "deckPosition": 0, "defenseAfter": 652, "defenseBefore": 652, "printedAttack": 287, "effectiveAttack": 287, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU13", "cardName": "Aram Vardanyan", "criticalHit": false, "damageDealt": 0, "struckFirst": false, "deckPosition": 0, "defenseAfter": 725, "defenseBefore": 1000, "printedAttack": 184, "effectiveAttack": 193, "hasFactionAdvantage": true}, "turnNumber": 1, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 500, "healthTwoAfter": 500, "replacementOne": null, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Aram Vardanyan ha il vantaggio di fazione: l'ATK sale da 184 a 193.\\nTiana Rabe è più veloce e colpisce per primo.\\nTiana Rabe infligge 257 danni a Aram Vardanyan. Aram Vardanyan scende a 468 DEF.\\nColpo critico di Aram Vardanyan!\\nAram Vardanyan infligge 297 danni a Tiana Rabe. Tiana Rabe scende a 355 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF02", "cardName": "Tiana Rabe", "criticalHit": false, "damageDealt": 257, "struckFirst": true, "deckPosition": 0, "defenseAfter": 355, "defenseBefore": 652, "printedAttack": 287, "effectiveAttack": 287, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU13", "cardName": "Aram Vardanyan", "criticalHit": true, "damageDealt": 297, "struckFirst": false, "deckPosition": 0, "defenseAfter": 468, "defenseBefore": 725, "printedAttack": 184, "effectiveAttack": 193, "hasFactionAdvantage": true}, "turnNumber": 1, "roundNumber": 2, "healthDamage": 0, "healthOneAfter": 500, "healthTwoAfter": 500, "replacementOne": null, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Aram Vardanyan ha il vantaggio di fazione: l'ATK sale da 184 a 193.\\nTiana Rabe è più veloce e colpisce per primo.\\nTiana Rabe infligge 298 danni a Aram Vardanyan. Aram Vardanyan scende a 170 DEF.\\nColpo critico di Aram Vardanyan!\\nAram Vardanyan infligge 312 danni a Tiana Rabe. Tiana Rabe scende a 43 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF02", "cardName": "Tiana Rabe", "criticalHit": false, "damageDealt": 298, "struckFirst": true, "deckPosition": 0, "defenseAfter": 43, "defenseBefore": 355, "printedAttack": 287, "effectiveAttack": 287, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU13", "cardName": "Aram Vardanyan", "criticalHit": true, "damageDealt": 312, "struckFirst": false, "deckPosition": 0, "defenseAfter": 170, "defenseBefore": 468, "printedAttack": 184, "effectiveAttack": 193, "hasFactionAdvantage": true}, "turnNumber": 1, "roundNumber": 3, "healthDamage": 0, "healthOneAfter": 500, "healthTwoAfter": 500, "replacementOne": null, "replacementTwo": null}, {"outcome": "SECOND_KNOCKED_OUT", "narration": "Aram Vardanyan ha il vantaggio di fazione: l'ATK sale da 184 a 193.\\nTiana Rabe è più veloce e colpisce per primo.\\nColpo critico di Tiana Rabe!\\nTiana Rabe infligge 170 danni a Aram Vardanyan. Aram Vardanyan scende a 0 DEF.\\nAram Vardanyan è KO.\\nIl giocatore 2 perde 238 punti vita e scende a 262.\\nIl giocatore 2 schiera Samir Haddad.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF02", "cardName": "Tiana Rabe", "criticalHit": true, "damageDealt": 170, "struckFirst": true, "deckPosition": 0, "defenseAfter": 43, "defenseBefore": 43, "printedAttack": 287, "effectiveAttack": 287, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU13", "cardName": "Aram Vardanyan", "criticalHit": false, "damageDealt": 0, "struckFirst": false, "deckPosition": 0, "defenseAfter": 0, "defenseBefore": 170, "printedAttack": 184, "effectiveAttack": 193, "hasFactionAdvantage": true}, "turnNumber": 1, "roundNumber": 4, "healthDamage": 238, "healthOneAfter": 500, "healthTwoAfter": 262, "replacementOne": null, "replacementTwo": {"code": "EU04", "name": "Samir Haddad", "deckPosition": 1}}, {"outcome": "FIRST_KNOCKED_OUT", "narration": "Samir Haddad ha il vantaggio di fazione: l'ATK sale da 247 a 259.\\nSamir Haddad è più veloce e colpisce per primo.\\nColpo critico di Samir Haddad!\\nSamir Haddad infligge 43 danni a Tiana Rabe. Tiana Rabe scende a 0 DEF.\\nTiana Rabe è KO.\\nIl giocatore 1 perde 307 punti vita e scende a 193.\\nIl giocatore 1 schiera Nia Kamau.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF02", "cardName": "Tiana Rabe", "criticalHit": false, "damageDealt": 0, "struckFirst": false, "deckPosition": 0, "defenseAfter": 0, "defenseBefore": 43, "printedAttack": 287, "effectiveAttack": 287, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU04", "cardName": "Samir Haddad", "criticalHit": true, "damageDealt": 43, "struckFirst": true, "deckPosition": 1, "defenseAfter": 460, "defenseBefore": 460, "printedAttack": 247, "effectiveAttack": 259, "hasFactionAdvantage": true}, "turnNumber": 2, "roundNumber": 1, "healthDamage": 307, "healthOneAfter": 193, "healthTwoAfter": 262, "replacementOne": {"code": "AF12", "name": "Nia Kamau", "deckPosition": 1}, "replacementTwo": null}, {"outcome": "SECOND_KNOCKED_OUT", "narration": "Samir Haddad ha il vantaggio di fazione: l'ATK sale da 247 a 259.\\nSamir Haddad è più veloce e colpisce per primo.\\nSamir Haddad infligge 228 danni a Nia Kamau. Nia Kamau scende a 372 DEF.\\nColpo critico di Nia Kamau!\\nNia Kamau infligge 460 danni a Samir Haddad. Samir Haddad scende a 0 DEF.\\nSamir Haddad è KO.\\nIl giocatore 2 perde 14 punti vita e scende a 248.\\nIl giocatore 2 schiera Aizada Bekova.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF12", "cardName": "Nia Kamau", "criticalHit": true, "damageDealt": 460, "struckFirst": false, "deckPosition": 1, "defenseAfter": 372, "defenseBefore": 600, "printedAttack": 318, "effectiveAttack": 318, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU04", "cardName": "Samir Haddad", "criticalHit": false, "damageDealt": 228, "struckFirst": true, "deckPosition": 1, "defenseAfter": 0, "defenseBefore": 460, "printedAttack": 247, "effectiveAttack": 259, "hasFactionAdvantage": true}, "turnNumber": 3, "roundNumber": 1, "healthDamage": 14, "healthOneAfter": 193, "healthTwoAfter": 248, "replacementOne": null, "replacementTwo": {"code": "EU15", "name": "Aizada Bekova", "deckPosition": 2}}, {"outcome": "NO_KNOCKOUT", "narration": "Aizada Bekova ha il vantaggio di fazione: l'ATK sale da 194 a 204.\\nAizada Bekova è più veloce e colpisce per primo.\\nColpo critico di Aizada Bekova!\\nAizada Bekova infligge 330 danni a Nia Kamau. Nia Kamau scende a 42 DEF.\\nNia Kamau infligge 308 danni a Aizada Bekova. Aizada Bekova scende a 692 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF12", "cardName": "Nia Kamau", "criticalHit": false, "damageDealt": 308, "struckFirst": false, "deckPosition": 1, "defenseAfter": 42, "defenseBefore": 372, "printedAttack": 318, "effectiveAttack": 318, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU15", "cardName": "Aizada Bekova", "criticalHit": true, "damageDealt": 330, "struckFirst": true, "deckPosition": 2, "defenseAfter": 692, "defenseBefore": 1000, "printedAttack": 194, "effectiveAttack": 204, "hasFactionAdvantage": true}, "turnNumber": 4, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 193, "healthTwoAfter": 248, "replacementOne": null, "replacementTwo": null}, {"outcome": "FIRST_KNOCKED_OUT", "narration": "Aizada Bekova ha il vantaggio di fazione: l'ATK sale da 194 a 204.\\nAizada Bekova è più veloce e colpisce per primo.\\nAizada Bekova infligge 42 danni a Nia Kamau. Nia Kamau scende a 0 DEF.\\nNia Kamau è KO.\\nIl giocatore 1 perde 187 punti vita e scende a 6.\\nIl giocatore 1 schiera Neema Mushi.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF12", "cardName": "Nia Kamau", "criticalHit": false, "damageDealt": 0, "struckFirst": false, "deckPosition": 1, "defenseAfter": 0, "defenseBefore": 42, "printedAttack": 318, "effectiveAttack": 318, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU15", "cardName": "Aizada Bekova", "criticalHit": false, "damageDealt": 42, "struckFirst": true, "deckPosition": 2, "defenseAfter": 692, "defenseBefore": 692, "printedAttack": 194, "effectiveAttack": 204, "hasFactionAdvantage": true}, "turnNumber": 4, "roundNumber": 2, "healthDamage": 187, "healthOneAfter": 6, "healthTwoAfter": 248, "replacementOne": {"code": "AF15", "name": "Neema Mushi", "deckPosition": 2}, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Aizada Bekova ha il vantaggio di fazione: l'ATK sale da 194 a 204.\\nAizada Bekova è più veloce e colpisce per primo.\\nAizada Bekova infligge 213 danni a Neema Mushi. Neema Mushi scende a 740 DEF.\\nNeema Mushi infligge 216 danni a Aizada Bekova. Aizada Bekova scende a 476 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF15", "cardName": "Neema Mushi", "criticalHit": false, "damageDealt": 216, "struckFirst": false, "deckPosition": 2, "defenseAfter": 740, "defenseBefore": 953, "printedAttack": 236, "effectiveAttack": 236, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU15", "cardName": "Aizada Bekova", "criticalHit": false, "damageDealt": 213, "struckFirst": true, "deckPosition": 2, "defenseAfter": 476, "defenseBefore": 692, "printedAttack": 194, "effectiveAttack": 204, "hasFactionAdvantage": true}, "turnNumber": 5, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 6, "healthTwoAfter": 248, "replacementOne": null, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Aizada Bekova ha il vantaggio di fazione: l'ATK sale da 194 a 204.\\nAizada Bekova è più veloce e colpisce per primo.\\nColpo critico di Aizada Bekova!\\nAizada Bekova infligge 315 danni a Neema Mushi. Neema Mushi scende a 425 DEF.\\nColpo critico di Neema Mushi!\\nNeema Mushi infligge 407 danni a Aizada Bekova. Aizada Bekova scende a 69 DEF.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF15", "cardName": "Neema Mushi", "criticalHit": true, "damageDealt": 407, "struckFirst": false, "deckPosition": 2, "defenseAfter": 425, "defenseBefore": 740, "printedAttack": 236, "effectiveAttack": 236, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU15", "cardName": "Aizada Bekova", "criticalHit": true, "damageDealt": 315, "struckFirst": true, "deckPosition": 2, "defenseAfter": 69, "defenseBefore": 476, "printedAttack": 194, "effectiveAttack": 204, "hasFactionAdvantage": true}, "turnNumber": 5, "roundNumber": 2, "healthDamage": 0, "healthOneAfter": 6, "healthTwoAfter": 248, "replacementOne": null, "replacementTwo": null}, {"outcome": "SECOND_KNOCKED_OUT", "narration": "Aizada Bekova ha il vantaggio di fazione: l'ATK sale da 194 a 204.\\nAizada Bekova è più veloce e colpisce per primo.\\nAizada Bekova infligge 233 danni a Neema Mushi. Neema Mushi scende a 192 DEF.\\nColpo critico di Neema Mushi!\\nNeema Mushi infligge 69 danni a Aizada Bekova. Aizada Bekova scende a 0 DEF.\\nAizada Bekova è KO.\\nIl giocatore 2 perde 248 punti vita e scende a 0.", "fighterOne": {"dodged": false, "faction": "AFRICAN", "cardCode": "AF15", "cardName": "Neema Mushi", "criticalHit": true, "damageDealt": 69, "struckFirst": false, "deckPosition": 2, "defenseAfter": 192, "defenseBefore": 425, "printedAttack": 236, "effectiveAttack": 236, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURASIAN", "cardCode": "EU15", "cardName": "Aizada Bekova", "criticalHit": false, "damageDealt": 233, "struckFirst": true, "deckPosition": 2, "defenseAfter": 0, "defenseBefore": 69, "printedAttack": 194, "effectiveAttack": 204, "hasFactionAdvantage": true}, "turnNumber": 5, "roundNumber": 3, "healthDamage": 248, "healthOneAfter": 6, "healthTwoAfter": 0, "replacementOne": null, "replacementTwo": null}], "summary": {"cards": [{"player": "ONE", "cardCode": "AF02", "knockouts": 1, "damageDealt": 1000, "damageTaken": 652, "deckPosition": 0, "roundsPlayed": 5, "enteredOnTurn": 1}, {"player": "ONE", "cardCode": "AF12", "knockouts": 1, "damageDealt": 768, "damageTaken": 600, "deckPosition": 1, "roundsPlayed": 3, "enteredOnTurn": 3}, {"player": "ONE", "cardCode": "AF15", "knockouts": 1, "damageDealt": 692, "damageTaken": 761, "deckPosition": 2, "roundsPlayed": 3, "enteredOnTurn": 5}, {"player": "TWO", "cardCode": "EU13", "knockouts": 0, "damageDealt": 609, "damageTaken": 1000, "deckPosition": 0, "roundsPlayed": 4, "enteredOnTurn": 1}, {"player": "TWO", "cardCode": "EU04", "knockouts": 1, "damageDealt": 271, "damageTaken": 460, "deckPosition": 1, "roundsPlayed": 2, "enteredOnTurn": 2}, {"player": "TWO", "cardCode": "EU15", "knockouts": 1, "damageDealt": 1133, "damageTaken": 1000, "deckPosition": 2, "roundsPlayed": 5, "enteredOnTurn": 4}], "outcome": "PLAYER_ONE_WINS", "endReason": "HEALTH_DEPLETED", "totalTurns": 5}, "deckOneOrder": ["AF02", "AF12", "AF15", "AF06", "AF13", "AF07", "AF14", "AF04", "AF03", "AF16"], "deckTwoOrder": ["EU13", "EU04", "EU15", "EU12", "EU08", "EU11", "EU14", "EU16", "EU02", "EU09"], "rulesVersion": 1}	2026-11-23 10:41:18.440366+00	2026-11-23 10:41:18.499099+00	[{"atk": 245, "crt": 550, "def": 652, "vel": 550, "code": "AF02", "name": "Tiana Rabe", "rarity": "Rara", "faction": "Africana", "subcards": ["SC01", "SC07"]}, {"atk": 265, "crt": 400, "def": 490, "vel": 850, "code": "AF06", "name": "Aya Koné", "rarity": "Rara", "faction": "Africana", "subcards": ["SC05", "SC06"]}, {"atk": 230, "crt": 550, "def": 638, "vel": 550, "code": "AF03", "name": "Kito Manuel", "rarity": "Comune", "faction": "Africana", "subcards": ["SC01", "SC07", "SC11"]}, {"atk": 235, "crt": 550, "def": 625, "vel": 550, "code": "AF04", "name": "Ines Mansour", "rarity": "Comune", "faction": "Africana", "subcards": ["SC01", "SC07", "SC11"]}, {"atk": 242, "crt": 400, "def": 495, "vel": 850, "code": "AF07", "name": "Nadir Belkacem", "rarity": "Comune", "faction": "Africana", "subcards": ["SC05", "SC06", "SC11"]}, {"atk": 312, "crt": 700, "def": 632, "vel": 250, "code": "AF12", "name": "Nia Kamau", "rarity": "Comune", "faction": "Africana", "subcards": ["SC04", "SC05", "SC11"]}, {"atk": 306, "crt": 700, "def": 646, "vel": 250, "code": "AF13", "name": "Malia Kanku", "rarity": "Comune", "faction": "Africana", "subcards": ["SC04", "SC05", "SC11"]}, {"atk": 296, "crt": 700, "def": 666, "vel": 250, "code": "AF14", "name": "Malick Diop", "rarity": "Comune", "faction": "Africana", "subcards": ["SC04", "SC05", "SC11"]}, {"atk": 202, "crt": 450, "def": 882, "vel": 400, "code": "AF15", "name": "Neema Mushi", "rarity": "Comune", "faction": "Africana", "subcards": ["SC01", "SC02", "SC07"]}, {"atk": 205, "crt": 475, "def": 864, "vel": 400, "code": "AF16", "name": "Dawit Bekele", "rarity": "Comune", "faction": "Africana", "subcards": ["SC01", "SC02", "SC07"]}]	[{"atk": 238, "crt": 600, "def": 665, "vel": 550, "code": "EU02", "name": "Arman Farhadi", "rarity": "Rara", "faction": "Eurasiatica", "subcards": ["SC06", "SC09"]}, {"atk": 263, "crt": 350, "def": 500, "vel": 850, "code": "EU04", "name": "Samir Haddad", "rarity": "Rara", "faction": "Eurasiatica", "subcards": ["SC03", "SC04"]}, {"atk": 191, "crt": 850, "def": 780, "vel": 500, "code": "EU08", "name": "Leyla Mammadova", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC04", "SC08", "SC12"]}, {"atk": 193, "crt": 850, "def": 772, "vel": 500, "code": "EU09", "name": "Iryna Koval", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC04", "SC08", "SC12"]}, {"atk": 301, "crt": 725, "def": 653, "vel": 250, "code": "EU11", "name": "Nurlan Saparov", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC01", "SC08", "SC12"]}, {"atk": 302, "crt": 700, "def": 653, "vel": 250, "code": "EU12", "name": "Baran Aksoy", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC01", "SC08", "SC12"]}, {"atk": 200, "crt": 450, "def": 891, "vel": 400, "code": "EU13", "name": "Aram Vardanyan", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC02", "SC06", "SC09"]}, {"atk": 204, "crt": 450, "def": 873, "vel": 400, "code": "EU14", "name": "Oksana Hrytsenko", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC02", "SC06", "SC09"]}, {"atk": 211, "crt": 450, "def": 846, "vel": 400, "code": "EU15", "name": "Aizada Bekova", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC02", "SC06", "SC09"]}, {"atk": 213, "crt": 450, "def": 837, "vel": 400, "code": "EU16", "name": "Radu Ionescu", "rarity": "Comune", "faction": "Eurasiatica", "subcards": ["SC02", "SC06", "SC09"]}]	ADVANCED
3	3	4	3	4	FINISHED	3	-6398183848567041207	{"mode": "ADVANCED", "seed": -6398183848567041207, "turns": [{"outcome": "NO_KNOCKOUT", "narration": "Diego Solís è più veloce e colpisce per primo.\\nDiego Solís infligge 302 danni a Maia Rangi. Maia Rangi scende a 698 DEF.\\nColpo critico di Maia Rangi!\\nMaia Rangi infligge 287 danni a Diego Solís. Diego Solís scende a 383 DEF.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA03", "cardName": "Diego Solís", "criticalHit": false, "damageDealt": 302, "struckFirst": true, "deckPosition": 0, "defenseAfter": 383, "defenseBefore": 670, "printedAttack": 275, "effectiveAttack": 275, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA15", "cardName": "Maia Rangi", "criticalHit": true, "damageDealt": 287, "struckFirst": false, "deckPosition": 0, "defenseAfter": 698, "defenseBefore": 1000, "printedAttack": 190, "effectiveAttack": 190, "hasFactionAdvantage": false}, "turnNumber": 1, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 500, "healthTwoAfter": 500, "replacementOne": null, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Diego Solís è più veloce e colpisce per primo.\\nColpo critico di Diego Solís!\\nDiego Solís infligge 431 danni a Maia Rangi. Maia Rangi scende a 267 DEF.\\nMaia Rangi infligge 206 danni a Diego Solís. Diego Solís scende a 177 DEF.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA03", "cardName": "Diego Solís", "criticalHit": true, "damageDealt": 431, "struckFirst": true, "deckPosition": 0, "defenseAfter": 177, "defenseBefore": 383, "printedAttack": 275, "effectiveAttack": 275, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA15", "cardName": "Maia Rangi", "criticalHit": false, "damageDealt": 206, "struckFirst": false, "deckPosition": 0, "defenseAfter": 267, "defenseBefore": 698, "printedAttack": 190, "effectiveAttack": 190, "hasFactionAdvantage": false}, "turnNumber": 1, "roundNumber": 2, "healthDamage": 0, "healthOneAfter": 500, "healthTwoAfter": 500, "replacementOne": null, "replacementTwo": null}, {"outcome": "FIRST_KNOCKED_OUT", "narration": "Diego Solís è più veloce e colpisce per primo.\\nDiego Solís infligge 244 danni a Maia Rangi. Maia Rangi scende a 23 DEF.\\nColpo critico di Maia Rangi!\\nMaia Rangi infligge 177 danni a Diego Solís. Diego Solís scende a 0 DEF.\\nDiego Solís è KO.\\nIl giocatore 1 perde 111 punti vita e scende a 389.\\nIl giocatore 1 schiera Sofia Vargas.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA03", "cardName": "Diego Solís", "criticalHit": false, "damageDealt": 244, "struckFirst": true, "deckPosition": 0, "defenseAfter": 0, "defenseBefore": 177, "printedAttack": 275, "effectiveAttack": 275, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA15", "cardName": "Maia Rangi", "criticalHit": true, "damageDealt": 177, "struckFirst": false, "deckPosition": 0, "defenseAfter": 23, "defenseBefore": 267, "printedAttack": 190, "effectiveAttack": 190, "hasFactionAdvantage": false}, "turnNumber": 1, "roundNumber": 3, "healthDamage": 111, "healthOneAfter": 389, "healthTwoAfter": 500, "replacementOne": {"code": "PA12", "name": "Sofia Vargas", "deckPosition": 1}, "replacementTwo": null}, {"outcome": "SECOND_KNOCKED_OUT", "narration": "Sofia Vargas è più veloce e colpisce per primo.\\nSofia Vargas infligge 23 danni a Maia Rangi. Maia Rangi scende a 0 DEF.\\nMaia Rangi è KO.\\nIl giocatore 2 perde 194 punti vita e scende a 306.\\nIl giocatore 2 schiera Tara Quinn.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA12", "cardName": "Sofia Vargas", "criticalHit": false, "damageDealt": 23, "struckFirst": true, "deckPosition": 1, "defenseAfter": 837, "defenseBefore": 837, "printedAttack": 191, "effectiveAttack": 191, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA15", "cardName": "Maia Rangi", "criticalHit": false, "damageDealt": 0, "struckFirst": false, "deckPosition": 0, "defenseAfter": 0, "defenseBefore": 23, "printedAttack": 190, "effectiveAttack": 190, "hasFactionAdvantage": false}, "turnNumber": 2, "roundNumber": 1, "healthDamage": 194, "healthOneAfter": 389, "healthTwoAfter": 306, "replacementOne": null, "replacementTwo": {"code": "EA11", "name": "Tara Quinn", "deckPosition": 1}}, {"outcome": "NO_KNOCKOUT", "narration": "Sofia Vargas è più veloce e colpisce per primo.\\nSofia Vargas infligge 195 danni a Tara Quinn. Tara Quinn scende a 602 DEF.\\nColpo critico di Tara Quinn!\\nTara Quinn infligge 333 danni a Sofia Vargas. Sofia Vargas scende a 504 DEF.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA12", "cardName": "Sofia Vargas", "criticalHit": false, "damageDealt": 195, "struckFirst": true, "deckPosition": 1, "defenseAfter": 504, "defenseBefore": 837, "printedAttack": 191, "effectiveAttack": 191, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA11", "cardName": "Tara Quinn", "criticalHit": true, "damageDealt": 333, "struckFirst": false, "deckPosition": 1, "defenseAfter": 602, "defenseBefore": 797, "printedAttack": 195, "effectiveAttack": 195, "hasFactionAdvantage": false}, "turnNumber": 3, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 389, "healthTwoAfter": 306, "replacementOne": null, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Sofia Vargas è più veloce e colpisce per primo.\\nSofia Vargas infligge 206 danni a Tara Quinn. Tara Quinn scende a 396 DEF.\\nTara Quinn infligge 223 danni a Sofia Vargas. Sofia Vargas scende a 281 DEF.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA12", "cardName": "Sofia Vargas", "criticalHit": false, "damageDealt": 206, "struckFirst": true, "deckPosition": 1, "defenseAfter": 281, "defenseBefore": 504, "printedAttack": 191, "effectiveAttack": 191, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA11", "cardName": "Tara Quinn", "criticalHit": false, "damageDealt": 223, "struckFirst": false, "deckPosition": 1, "defenseAfter": 396, "defenseBefore": 602, "printedAttack": 195, "effectiveAttack": 195, "hasFactionAdvantage": false}, "turnNumber": 3, "roundNumber": 2, "healthDamage": 0, "healthOneAfter": 389, "healthTwoAfter": 306, "replacementOne": null, "replacementTwo": null}, {"outcome": "FIRST_KNOCKED_OUT", "narration": "Sofia Vargas è più veloce e colpisce per primo.\\nSofia Vargas infligge 198 danni a Tara Quinn. Tara Quinn scende a 198 DEF.\\nColpo critico di Tara Quinn!\\nTara Quinn infligge 281 danni a Sofia Vargas. Sofia Vargas scende a 0 DEF.\\nSofia Vargas è KO.\\nIl giocatore 1 perde 16 punti vita e scende a 373.\\nIl giocatore 1 schiera Camila Reyes.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA12", "cardName": "Sofia Vargas", "criticalHit": false, "damageDealt": 198, "struckFirst": true, "deckPosition": 1, "defenseAfter": 0, "defenseBefore": 281, "printedAttack": 191, "effectiveAttack": 191, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA11", "cardName": "Tara Quinn", "criticalHit": true, "damageDealt": 281, "struckFirst": false, "deckPosition": 1, "defenseAfter": 198, "defenseBefore": 396, "printedAttack": 195, "effectiveAttack": 195, "hasFactionAdvantage": false}, "turnNumber": 3, "roundNumber": 3, "healthDamage": 16, "healthOneAfter": 373, "healthTwoAfter": 306, "replacementOne": {"code": "PA02", "name": "Camila Reyes", "deckPosition": 2}, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Camila Reyes è più veloce e colpisce per primo.\\nTara Quinn schiva il colpo di Camila Reyes!\\nTara Quinn infligge 209 danni a Camila Reyes. Camila Reyes scende a 443 DEF.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA02", "cardName": "Camila Reyes", "criticalHit": false, "damageDealt": 0, "struckFirst": true, "deckPosition": 2, "defenseAfter": 443, "defenseBefore": 652, "printedAttack": 287, "effectiveAttack": 287, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": true, "faction": "EURO_ATLANTIC", "cardCode": "EA11", "cardName": "Tara Quinn", "criticalHit": false, "damageDealt": 209, "struckFirst": false, "deckPosition": 1, "defenseAfter": 198, "defenseBefore": 198, "printedAttack": 195, "effectiveAttack": 195, "hasFactionAdvantage": false}, "turnNumber": 4, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 373, "healthTwoAfter": 306, "replacementOne": null, "replacementTwo": null}, {"outcome": "SECOND_KNOCKED_OUT", "narration": "Camila Reyes è più veloce e colpisce per primo.\\nCamila Reyes infligge 198 danni a Tara Quinn. Tara Quinn scende a 0 DEF.\\nTara Quinn è KO.\\nIl giocatore 2 perde 118 punti vita e scende a 188.\\nIl giocatore 2 schiera Nico Valenti.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA02", "cardName": "Camila Reyes", "criticalHit": false, "damageDealt": 198, "struckFirst": true, "deckPosition": 2, "defenseAfter": 443, "defenseBefore": 443, "printedAttack": 287, "effectiveAttack": 287, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA11", "cardName": "Tara Quinn", "criticalHit": false, "damageDealt": 0, "struckFirst": false, "deckPosition": 1, "defenseAfter": 0, "defenseBefore": 198, "printedAttack": 195, "effectiveAttack": 195, "hasFactionAdvantage": false}, "turnNumber": 4, "roundNumber": 2, "healthDamage": 118, "healthOneAfter": 373, "healthTwoAfter": 188, "replacementOne": null, "replacementTwo": {"code": "EA02", "name": "Nico Valenti", "deckPosition": 2}}, {"outcome": "NO_KNOCKOUT", "narration": "Nico Valenti è più veloce e colpisce per primo.\\nCamila Reyes schiva il colpo di Nico Valenti!\\nCamila Reyes infligge 289 danni a Nico Valenti. Nico Valenti scende a 511 DEF.", "fighterOne": {"dodged": true, "faction": "PAN_AMERICAN", "cardCode": "PA02", "cardName": "Camila Reyes", "criticalHit": false, "damageDealt": 289, "struckFirst": false, "deckPosition": 2, "defenseAfter": 443, "defenseBefore": 443, "printedAttack": 287, "effectiveAttack": 287, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA02", "cardName": "Nico Valenti", "criticalHit": false, "damageDealt": 0, "struckFirst": true, "deckPosition": 2, "defenseAfter": 511, "defenseBefore": 800, "printedAttack": 216, "effectiveAttack": 216, "hasFactionAdvantage": false}, "turnNumber": 5, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 373, "healthTwoAfter": 188, "replacementOne": null, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Nico Valenti è più veloce e colpisce per primo.\\nNico Valenti infligge 184 danni a Camila Reyes. Camila Reyes scende a 259 DEF.\\nCamila Reyes infligge 259 danni a Nico Valenti. Nico Valenti scende a 252 DEF.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA02", "cardName": "Camila Reyes", "criticalHit": false, "damageDealt": 259, "struckFirst": false, "deckPosition": 2, "defenseAfter": 259, "defenseBefore": 443, "printedAttack": 287, "effectiveAttack": 287, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA02", "cardName": "Nico Valenti", "criticalHit": false, "damageDealt": 184, "struckFirst": true, "deckPosition": 2, "defenseAfter": 252, "defenseBefore": 511, "printedAttack": 216, "effectiveAttack": 216, "hasFactionAdvantage": false}, "turnNumber": 5, "roundNumber": 2, "healthDamage": 0, "healthOneAfter": 373, "healthTwoAfter": 188, "replacementOne": null, "replacementTwo": null}, {"outcome": "FIRST_KNOCKED_OUT", "narration": "Nico Valenti è più veloce e colpisce per primo.\\nColpo critico di Nico Valenti!\\nNico Valenti infligge 259 danni a Camila Reyes. Camila Reyes scende a 0 DEF.\\nCamila Reyes è KO.\\nIl giocatore 1 perde 76 punti vita e scende a 297.\\nIl giocatore 1 schiera Elena Cárdenas.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA02", "cardName": "Camila Reyes", "criticalHit": false, "damageDealt": 0, "struckFirst": false, "deckPosition": 2, "defenseAfter": 0, "defenseBefore": 259, "printedAttack": 287, "effectiveAttack": 287, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA02", "cardName": "Nico Valenti", "criticalHit": true, "damageDealt": 259, "struckFirst": true, "deckPosition": 2, "defenseAfter": 252, "defenseBefore": 252, "printedAttack": 216, "effectiveAttack": 216, "hasFactionAdvantage": false}, "turnNumber": 5, "roundNumber": 3, "healthDamage": 76, "healthOneAfter": 297, "healthTwoAfter": 188, "replacementOne": {"code": "PA07", "name": "Elena Cárdenas", "deckPosition": 3}, "replacementTwo": null}, {"outcome": "NO_KNOCKOUT", "narration": "Elena Cárdenas è più veloce e colpisce per primo.\\nElena Cárdenas infligge 225 danni a Nico Valenti. Nico Valenti scende a 27 DEF.\\nNico Valenti infligge 202 danni a Elena Cárdenas. Elena Cárdenas scende a 293 DEF.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA07", "cardName": "Elena Cárdenas", "criticalHit": false, "damageDealt": 225, "struckFirst": true, "deckPosition": 3, "defenseAfter": 293, "defenseBefore": 495, "printedAttack": 257, "effectiveAttack": 257, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA02", "cardName": "Nico Valenti", "criticalHit": false, "damageDealt": 202, "struckFirst": false, "deckPosition": 2, "defenseAfter": 27, "defenseBefore": 252, "printedAttack": 216, "effectiveAttack": 216, "hasFactionAdvantage": false}, "turnNumber": 6, "roundNumber": 1, "healthDamage": 0, "healthOneAfter": 297, "healthTwoAfter": 188, "replacementOne": null, "replacementTwo": null}, {"outcome": "SECOND_KNOCKED_OUT", "narration": "Elena Cárdenas è più veloce e colpisce per primo.\\nElena Cárdenas infligge 27 danni a Nico Valenti. Nico Valenti scende a 0 DEF.\\nNico Valenti è KO.\\nIl giocatore 2 perde 188 punti vita e scende a 0.", "fighterOne": {"dodged": false, "faction": "PAN_AMERICAN", "cardCode": "PA07", "cardName": "Elena Cárdenas", "criticalHit": false, "damageDealt": 27, "struckFirst": true, "deckPosition": 3, "defenseAfter": 293, "defenseBefore": 293, "printedAttack": 257, "effectiveAttack": 257, "hasFactionAdvantage": false}, "fighterTwo": {"dodged": false, "faction": "EURO_ATLANTIC", "cardCode": "EA02", "cardName": "Nico Valenti", "criticalHit": false, "damageDealt": 0, "struckFirst": false, "deckPosition": 2, "defenseAfter": 0, "defenseBefore": 27, "printedAttack": 216, "effectiveAttack": 216, "hasFactionAdvantage": false}, "turnNumber": 6, "roundNumber": 2, "healthDamage": 188, "healthOneAfter": 297, "healthTwoAfter": 0, "replacementOne": null, "replacementTwo": null}], "summary": {"cards": [{"player": "ONE", "cardCode": "PA03", "knockouts": 0, "damageDealt": 977, "damageTaken": 670, "deckPosition": 0, "roundsPlayed": 3, "enteredOnTurn": 1}, {"player": "ONE", "cardCode": "PA12", "knockouts": 1, "damageDealt": 622, "damageTaken": 837, "deckPosition": 1, "roundsPlayed": 4, "enteredOnTurn": 2}, {"player": "ONE", "cardCode": "PA02", "knockouts": 1, "damageDealt": 746, "damageTaken": 652, "deckPosition": 2, "roundsPlayed": 5, "enteredOnTurn": 4}, {"player": "ONE", "cardCode": "PA07", "knockouts": 1, "damageDealt": 252, "damageTaken": 202, "deckPosition": 3, "roundsPlayed": 2, "enteredOnTurn": 6}, {"player": "TWO", "cardCode": "EA15", "knockouts": 1, "damageDealt": 670, "damageTaken": 1000, "deckPosition": 0, "roundsPlayed": 4, "enteredOnTurn": 1}, {"player": "TWO", "cardCode": "EA11", "knockouts": 1, "damageDealt": 1046, "damageTaken": 797, "deckPosition": 1, "roundsPlayed": 5, "enteredOnTurn": 3}, {"player": "TWO", "cardCode": "EA02", "knockouts": 1, "damageDealt": 645, "damageTaken": 800, "deckPosition": 2, "roundsPlayed": 5, "enteredOnTurn": 5}], "outcome": "PLAYER_ONE_WINS", "endReason": "HEALTH_DEPLETED", "totalTurns": 6}, "deckOneOrder": ["PA03", "PA12", "PA02", "PA07", "PA08", "PA09", "PA14", "PA15", "PA04", "PA16"], "deckTwoOrder": ["EA15", "EA11", "EA02", "EA10", "EA05", "EA16", "EA07", "EA06", "EA13", "EA14"], "rulesVersion": 1}	2026-11-23 10:41:18.520794+00	2026-11-23 10:41:18.571764+00	[{"atk": 245, "crt": 550, "def": 652, "vel": 550, "code": "PA02", "name": "Camila Reyes", "rarity": "Rara", "faction": "Panamericana", "subcards": ["SC01", "SC07"]}, {"atk": 265, "crt": 400, "def": 490, "vel": 850, "code": "PA07", "name": "Elena Cárdenas", "rarity": "Rara", "faction": "Panamericana", "subcards": ["SC05", "SC06"]}, {"atk": 229, "crt": 575, "def": 638, "vel": 550, "code": "PA03", "name": "Diego Solís", "rarity": "Comune", "faction": "Panamericana", "subcards": ["SC01", "SC07", "SC11"]}, {"atk": 223, "crt": 550, "def": 658, "vel": 550, "code": "PA04", "name": "Tomás Valencia", "rarity": "Comune", "faction": "Panamericana", "subcards": ["SC01", "SC07", "SC11"]}, {"atk": 257, "crt": 400, "def": 465, "vel": 850, "code": "PA08", "name": "Ixchel Morales", "rarity": "Comune", "faction": "Panamericana", "subcards": ["SC05", "SC06", "SC11"]}, {"atk": 252, "crt": 400, "def": 475, "vel": 850, "code": "PA09", "name": "Bruno Acosta", "rarity": "Comune", "faction": "Panamericana", "subcards": ["SC05", "SC06", "SC11"]}, {"atk": 185, "crt": 850, "def": 805, "vel": 500, "code": "PA12", "name": "Sofia Vargas", "rarity": "Comune", "faction": "Panamericana", "subcards": ["SC03", "SC09", "SC11"]}, {"atk": 306, "crt": 700, "def": 646, "vel": 250, "code": "PA14", "name": "Héctor Castillo", "rarity": "Comune", "faction": "Panamericana", "subcards": ["SC04", "SC05", "SC11"]}, {"atk": 213, "crt": 450, "def": 837, "vel": 400, "code": "PA15", "name": "Lucía Quispe", "rarity": "Comune", "faction": "Panamericana", "subcards": ["SC01", "SC02", "SC07"]}, {"atk": 209, "crt": 450, "def": 855, "vel": 400, "code": "PA16", "name": "Marcus Reid", "rarity": "Comune", "faction": "Panamericana", "subcards": ["SC01", "SC02", "SC07"]}]	[{"atk": 235, "crt": 550, "def": 678, "vel": 550, "code": "EA02", "name": "Nico Valenti", "rarity": "Rara", "faction": "Euroatlantica", "subcards": ["SC06", "SC09"]}, {"atk": 257, "crt": 450, "def": 500, "vel": 850, "code": "EA05", "name": "Luc Moreau", "rarity": "Rara", "faction": "Euroatlantica", "subcards": ["SC03", "SC04"]}, {"atk": 247, "crt": 400, "def": 485, "vel": 850, "code": "EA06", "name": "Seo Yuna", "rarity": "Comune", "faction": "Euroatlantica", "subcards": ["SC03", "SC04", "SC10"]}, {"atk": 250, "crt": 400, "def": 480, "vel": 850, "code": "EA07", "name": "Tiago Vale", "rarity": "Comune", "faction": "Euroatlantica", "subcards": ["SC03", "SC04", "SC10"]}, {"atk": 189, "crt": 850, "def": 789, "vel": 500, "code": "EA10", "name": "Erik Nyström", "rarity": "Comune", "faction": "Euroatlantica", "subcards": ["SC04", "SC08", "SC12"]}, {"atk": 181, "crt": 850, "def": 822, "vel": 500, "code": "EA11", "name": "Tara Quinn", "rarity": "Comune", "faction": "Euroatlantica", "subcards": ["SC04", "SC08", "SC12"]}, {"atk": 309, "crt": 700, "def": 639, "vel": 250, "code": "EA13", "name": "Darius King", "rarity": "Comune", "faction": "Euroatlantica", "subcards": ["SC01", "SC08", "SC12"]}, {"atk": 209, "crt": 450, "def": 855, "vel": 400, "code": "EA14", "name": "Aino Korhonen", "rarity": "Comune", "faction": "Euroatlantica", "subcards": ["SC02", "SC06", "SC09"]}, {"atk": 206, "crt": 450, "def": 864, "vel": 400, "code": "EA15", "name": "Maia Rangi", "rarity": "Comune", "faction": "Euroatlantica", "subcards": ["SC02", "SC06", "SC09"]}, {"atk": 202, "crt": 450, "def": 882, "vel": 400, "code": "EA16", "name": "Evelyn Brooks", "rarity": "Comune", "faction": "Euroatlantica", "subcards": ["SC02", "SC06", "SC09"]}]	ADVANCED
\.


--
-- Data for Name: pack; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pack (id, name, description, price, active) FROM stdin;
1	Pacchetto Base	5 carte: 4 comuni, 1 rara	100	t
2	Pacchetto Avanzato	8 carte: 5 comuni, 2 rare, 1 epica	220	t
3	Pacchetto Leggendario	10 carte: 1 leggendaria garantita	500	t
\.


--
-- Data for Name: pack_content; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pack_content (pack_id, rarity_id, card_count) FROM stdin;
1	1	4
1	2	1
2	1	5
2	2	2
2	3	1
3	1	6
3	2	2
3	3	1
3	4	1
\.


--
-- Data for Name: pack_opening; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pack_opening (id, user_id, pack_id, cards, idempotency_key, created_at) FROM stdin;
\.


--
-- Data for Name: rarity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rarity (id, name, rank) FROM stdin;
1	Comune	1
2	Rara	2
3	Epica	3
4	Leggendaria	4
\.


--
-- Data for Name: subcard; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subcard (id, code, name, description, atk_percent, def_percent, vel_percent, crt_percent) FROM stdin;
1	SC01	Guanti pesanti	Colpi più duri, movimenti più lenti.	12	0	-8	0
2	SC02	Corazza leggera	Più protezione al prezzo di un po' di agilità.	0	8	-6	0
3	SC03	Adrenalina	Più colpi critici, guardia più scoperta.	0	-8	0	11
4	SC04	Mirino tattico	Molti più critici, colpi base meno potenti.	-6	0	0	14
5	SC05	Stimolante	Attacco e critico salgono, la difesa cala.	5	-10	0	5
6	SC06	Scudo reattivo	Difesa solida, attacco più trattenuto.	-8	11	0	0
7	SC07	Colpo d'incontro	Più forza e precisione, meno rapidità.	5	0	-6	4
8	SC08	Colpo caricato	Un attacco devastante che lascia esposti.	11	-6	-6	0
9	SC09	Resistenza	Più tenuta, meno colpi critici.	0	7	0	-6
10	SC10	Concentrazione	Più critici e più tenuta, meno rapidità.	0	3	-8	8
11	SC11	Fasce rinforzate	Più robusto e un po' più forte, meno critici.	3	5	0	-8
12	SC12	Allenamento totale	Attacco e difesa migliorano, velocità e critico calano.	3	3	-5	-5
\.


--
-- Data for Name: trade; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.trade (id, sender_id, recipient_id, status, created_at, resolved_at) FROM stdin;
\.


--
-- Data for Name: trade_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.trade_item (trade_id, card_id, quantity, side) FROM stdin;
\.


--
-- Data for Name: user_card; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_card (user_id, card_id, quantity) FROM stdin;
1	2	1
1	3	2
1	4	2
1	6	1
1	7	2
1	9	1
1	10	1
1	12	2
1	13	2
1	14	2
1	15	2
1	16	2
1	34	1
1	37	1
1	38	2
1	39	2
1	41	1
1	42	2
1	43	2
1	44	1
1	45	2
1	46	2
1	47	2
1	48	2
1	18	1
1	20	1
1	23	1
1	24	2
1	25	2
1	26	1
1	27	2
1	28	2
1	29	2
1	30	2
1	31	2
1	32	2
1	50	1
1	51	2
1	53	1
1	55	1
1	56	1
1	57	2
1	58	2
1	59	2
1	60	2
1	61	2
1	62	2
1	64	2
1	66	1
1	67	2
1	68	2
1	71	1
1	72	2
1	73	2
1	75	1
1	76	2
1	77	1
1	78	2
1	79	2
1	80	2
2	2	1
2	3	2
2	4	2
2	6	1
2	7	2
2	9	1
2	10	1
2	12	2
2	13	2
2	14	2
2	15	2
2	16	2
2	34	1
2	37	1
2	38	2
2	39	2
2	41	1
2	42	2
2	43	2
2	44	1
2	45	2
2	46	2
2	47	2
2	48	2
2	18	1
2	20	1
2	23	1
2	24	2
2	25	2
2	26	1
2	27	2
2	28	2
2	29	2
2	30	2
2	31	2
2	32	2
2	50	1
2	51	2
2	53	1
2	55	1
2	56	1
2	57	2
2	58	2
2	59	2
2	60	2
2	61	2
2	62	2
2	64	2
2	66	1
2	67	2
2	68	2
2	71	1
2	72	2
2	73	2
2	75	1
2	76	2
2	77	1
2	78	2
2	79	2
2	80	2
3	2	1
3	3	2
3	4	2
3	6	1
3	7	2
3	9	1
3	10	1
3	12	2
3	13	2
3	14	2
3	15	2
3	16	2
3	34	1
3	37	1
3	38	2
3	39	2
3	41	1
3	42	2
3	43	2
3	44	1
3	45	2
3	46	2
3	47	2
3	48	2
3	18	1
3	20	1
3	23	1
3	24	2
3	25	2
3	26	1
3	27	2
3	28	2
3	29	2
3	30	2
3	31	2
3	32	2
3	50	1
3	51	2
3	53	1
3	55	1
3	56	1
3	57	2
3	58	2
3	59	2
3	60	2
3	61	2
3	62	2
3	64	2
3	66	1
3	67	2
3	68	2
3	71	1
3	72	2
3	73	2
3	75	1
3	76	2
3	77	1
3	78	2
3	79	2
3	80	2
4	2	1
4	3	2
4	4	2
4	6	1
4	7	2
4	9	1
4	10	1
4	12	2
4	13	2
4	14	2
4	15	2
4	16	2
4	34	1
4	37	1
4	38	2
4	39	2
4	41	1
4	42	2
4	43	2
4	44	1
4	45	2
4	46	2
4	47	2
4	48	2
4	18	1
4	20	1
4	23	1
4	24	2
4	25	2
4	26	1
4	27	2
4	28	2
4	29	2
4	30	2
4	31	2
4	32	2
4	50	1
4	51	2
4	53	1
4	55	1
4	56	1
4	57	2
4	58	2
4	59	2
4	60	2
4	61	2
4	62	2
4	64	2
4	66	1
4	67	2
4	68	2
4	71	1
4	72	2
4	73	2
4	75	1
4	76	2
4	77	1
4	78	2
4	79	2
4	80	2
\.


--
-- Name: app_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.app_user_id_seq', 4, true);


--
-- Name: card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.card_id_seq', 80, true);


--
-- Name: credit_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.credit_transaction_id_seq', 7, true);


--
-- Name: deck_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.deck_id_seq', 4, true);


--
-- Name: friendship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.friendship_id_seq', 1, true);


--
-- Name: match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.match_id_seq', 3, true);


--
-- Name: pack_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pack_id_seq', 3, true);


--
-- Name: pack_opening_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pack_opening_id_seq', 1, false);


--
-- Name: subcard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.subcard_id_seq', 12, true);


--
-- Name: trade_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.trade_id_seq', 1, false);


--
-- Name: app_user app_user_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_email_key UNIQUE (email);


--
-- Name: app_user app_user_nickname_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_nickname_key UNIQUE (nickname);


--
-- Name: app_user app_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_pkey PRIMARY KEY (id);


--
-- Name: card card_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.card
    ADD CONSTRAINT card_code_key UNIQUE (code);


--
-- Name: card card_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.card
    ADD CONSTRAINT card_pkey PRIMARY KEY (id);


--
-- Name: credit_transaction credit_transaction_idempotency_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credit_transaction
    ADD CONSTRAINT credit_transaction_idempotency_key_key UNIQUE (idempotency_key);


--
-- Name: credit_transaction credit_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credit_transaction
    ADD CONSTRAINT credit_transaction_pkey PRIMARY KEY (id);


--
-- Name: daily_claim daily_claim_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_claim
    ADD CONSTRAINT daily_claim_pkey PRIMARY KEY (user_id);


--
-- Name: deck_card deck_card_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deck_card
    ADD CONSTRAINT deck_card_pkey PRIMARY KEY (deck_id, card_id);


--
-- Name: deck_card_subcard deck_card_subcard_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deck_card_subcard
    ADD CONSTRAINT deck_card_subcard_pkey PRIMARY KEY (deck_id, card_id, subcard_id);


--
-- Name: deck deck_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deck
    ADD CONSTRAINT deck_pkey PRIMARY KEY (id);


--
-- Name: deck deck_user_id_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deck
    ADD CONSTRAINT deck_user_id_name_key UNIQUE (user_id, name);


--
-- Name: faction faction_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faction
    ADD CONSTRAINT faction_name_key UNIQUE (name);


--
-- Name: faction faction_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faction
    ADD CONSTRAINT faction_pkey PRIMARY KEY (id);


--
-- Name: fighter_class fighter_class_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fighter_class
    ADD CONSTRAINT fighter_class_name_key UNIQUE (name);


--
-- Name: fighter_class fighter_class_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fighter_class
    ADD CONSTRAINT fighter_class_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: friendship friendship_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendship
    ADD CONSTRAINT friendship_pkey PRIMARY KEY (id);


--
-- Name: match match_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match
    ADD CONSTRAINT match_pkey PRIMARY KEY (id);


--
-- Name: pack_content pack_content_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pack_content
    ADD CONSTRAINT pack_content_pkey PRIMARY KEY (pack_id, rarity_id);


--
-- Name: pack pack_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pack
    ADD CONSTRAINT pack_name_key UNIQUE (name);


--
-- Name: pack_opening pack_opening_idempotency_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pack_opening
    ADD CONSTRAINT pack_opening_idempotency_key_key UNIQUE (idempotency_key);


--
-- Name: pack_opening pack_opening_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pack_opening
    ADD CONSTRAINT pack_opening_pkey PRIMARY KEY (id);


--
-- Name: pack pack_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pack
    ADD CONSTRAINT pack_pkey PRIMARY KEY (id);


--
-- Name: rarity rarity_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rarity
    ADD CONSTRAINT rarity_name_key UNIQUE (name);


--
-- Name: rarity rarity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rarity
    ADD CONSTRAINT rarity_pkey PRIMARY KEY (id);


--
-- Name: rarity rarity_rank_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rarity
    ADD CONSTRAINT rarity_rank_key UNIQUE (rank);


--
-- Name: subcard subcard_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcard
    ADD CONSTRAINT subcard_code_key UNIQUE (code);


--
-- Name: subcard subcard_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcard
    ADD CONSTRAINT subcard_pkey PRIMARY KEY (id);


--
-- Name: trade_item trade_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trade_item
    ADD CONSTRAINT trade_item_pkey PRIMARY KEY (trade_id, card_id, side);


--
-- Name: trade trade_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trade
    ADD CONSTRAINT trade_pkey PRIMARY KEY (id);


--
-- Name: user_card user_card_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_card
    ADD CONSTRAINT user_card_pkey PRIMARY KEY (user_id, card_id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: friendship_pair_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX friendship_pair_key ON public.friendship USING btree (LEAST(requester_id, addressee_id), GREATEST(requester_id, addressee_id));


--
-- Name: idx_card_faction; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_card_faction ON public.card USING btree (faction_id);


--
-- Name: idx_card_rarity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_card_rarity ON public.card USING btree (rarity_id);


--
-- Name: idx_credit_transaction_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_credit_transaction_user ON public.credit_transaction USING btree (user_id);


--
-- Name: idx_deck_card_card; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_deck_card_card ON public.deck_card USING btree (card_id);


--
-- Name: idx_match_challenger; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_match_challenger ON public.match USING btree (challenger_id);


--
-- Name: idx_match_opponent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_match_opponent ON public.match USING btree (opponent_id);


--
-- Name: idx_pack_opening_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pack_opening_user ON public.pack_opening USING btree (user_id);


--
-- Name: idx_trade_recipient; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_trade_recipient ON public.trade USING btree (recipient_id);


--
-- Name: idx_trade_sender; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_trade_sender ON public.trade USING btree (sender_id);


--
-- Name: idx_user_card_card; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_card_card ON public.user_card USING btree (card_id);


--
-- Name: card card_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.card
    ADD CONSTRAINT card_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.fighter_class(id);


--
-- Name: card card_faction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.card
    ADD CONSTRAINT card_faction_id_fkey FOREIGN KEY (faction_id) REFERENCES public.faction(id);


--
-- Name: card card_rarity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.card
    ADD CONSTRAINT card_rarity_id_fkey FOREIGN KEY (rarity_id) REFERENCES public.rarity(id);


--
-- Name: credit_transaction credit_transaction_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credit_transaction
    ADD CONSTRAINT credit_transaction_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_user(id);


--
-- Name: daily_claim daily_claim_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_claim
    ADD CONSTRAINT daily_claim_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_user(id);


--
-- Name: deck_card deck_card_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deck_card
    ADD CONSTRAINT deck_card_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.card(id);


--
-- Name: deck_card deck_card_deck_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deck_card
    ADD CONSTRAINT deck_card_deck_id_fkey FOREIGN KEY (deck_id) REFERENCES public.deck(id) ON DELETE CASCADE;


--
-- Name: deck_card_subcard deck_card_subcard_deck_id_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deck_card_subcard
    ADD CONSTRAINT deck_card_subcard_deck_id_card_id_fkey FOREIGN KEY (deck_id, card_id) REFERENCES public.deck_card(deck_id, card_id) ON DELETE CASCADE;


--
-- Name: deck_card_subcard deck_card_subcard_subcard_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deck_card_subcard
    ADD CONSTRAINT deck_card_subcard_subcard_id_fkey FOREIGN KEY (subcard_id) REFERENCES public.subcard(id);


--
-- Name: deck deck_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deck
    ADD CONSTRAINT deck_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_user(id);


--
-- Name: friendship friendship_addressee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendship
    ADD CONSTRAINT friendship_addressee_id_fkey FOREIGN KEY (addressee_id) REFERENCES public.app_user(id);


--
-- Name: friendship friendship_requester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendship
    ADD CONSTRAINT friendship_requester_id_fkey FOREIGN KEY (requester_id) REFERENCES public.app_user(id);


--
-- Name: match match_challenger_deck_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match
    ADD CONSTRAINT match_challenger_deck_id_fkey FOREIGN KEY (challenger_deck_id) REFERENCES public.deck(id) ON DELETE SET NULL;


--
-- Name: match match_challenger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match
    ADD CONSTRAINT match_challenger_id_fkey FOREIGN KEY (challenger_id) REFERENCES public.app_user(id);


--
-- Name: match match_opponent_deck_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match
    ADD CONSTRAINT match_opponent_deck_id_fkey FOREIGN KEY (opponent_deck_id) REFERENCES public.deck(id) ON DELETE SET NULL;


--
-- Name: match match_opponent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match
    ADD CONSTRAINT match_opponent_id_fkey FOREIGN KEY (opponent_id) REFERENCES public.app_user(id);


--
-- Name: match match_winner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match
    ADD CONSTRAINT match_winner_id_fkey FOREIGN KEY (winner_id) REFERENCES public.app_user(id);


--
-- Name: pack_content pack_content_pack_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pack_content
    ADD CONSTRAINT pack_content_pack_id_fkey FOREIGN KEY (pack_id) REFERENCES public.pack(id) ON DELETE CASCADE;


--
-- Name: pack_content pack_content_rarity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pack_content
    ADD CONSTRAINT pack_content_rarity_id_fkey FOREIGN KEY (rarity_id) REFERENCES public.rarity(id);


--
-- Name: pack_opening pack_opening_pack_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pack_opening
    ADD CONSTRAINT pack_opening_pack_id_fkey FOREIGN KEY (pack_id) REFERENCES public.pack(id);


--
-- Name: pack_opening pack_opening_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pack_opening
    ADD CONSTRAINT pack_opening_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_user(id);


--
-- Name: trade_item trade_item_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trade_item
    ADD CONSTRAINT trade_item_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.card(id);


--
-- Name: trade_item trade_item_trade_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trade_item
    ADD CONSTRAINT trade_item_trade_id_fkey FOREIGN KEY (trade_id) REFERENCES public.trade(id) ON DELETE CASCADE;


--
-- Name: trade trade_recipient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trade
    ADD CONSTRAINT trade_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public.app_user(id);


--
-- Name: trade trade_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trade
    ADD CONSTRAINT trade_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.app_user(id);


--
-- Name: user_card user_card_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_card
    ADD CONSTRAINT user_card_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.card(id);


--
-- Name: user_card user_card_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_card
    ADD CONSTRAINT user_card_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_user(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 0ovVwYwjku37gvkhfkMUzd3eT6ZAUoKQVf29CfdWV4vXONnoEcuH5U05mR3lJwk

