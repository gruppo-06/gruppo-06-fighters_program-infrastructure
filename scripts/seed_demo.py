"""Creates the demo data through the backend API: four players, their decks with sub-cards,
a few finished matches and a pending friend request. Safe to run twice: it skips what exists.

Usage: python3 scripts/seed_demo.py [API base URL, default http://localhost:8080/api]
"""
import json
import sys
import urllib.error
import urllib.request

API = sys.argv[1] if len(sys.argv) > 1 else "http://localhost:8080/api"
PASSWORD = "fighters-demo-1"

BEST_SUBCARDS = {
    "Combattenti": ["SC01", "SC07", "SC11"],
    "Assassini": ["SC05", "SC06", "SC11"],
    "Specialisti": ["SC03", "SC09", "SC11"],
    "Colossi": ["SC04", "SC05", "SC11"],
    "Sentinelle": ["SC01", "SC02", "SC07"],
}
ALTERNATIVE_SUBCARDS = {
    "Combattenti": ["SC06", "SC09", "SC12"],
    "Assassini": ["SC04", "SC03", "SC10"],
    "Specialisti": ["SC08", "SC04", "SC12"],
    "Colossi": ["SC08", "SC01", "SC12"],
    "Sentinelle": ["SC02", "SC06", "SC09"],
}
SLOTS = {"Comune": 3, "Rara": 2, "Epica": 1, "Leggendaria": 0}
PLAYERS = [
    ("sara", "Furia del Sud", "Africana", BEST_SUBCARDS),
    ("marco", "Muro d'Acciaio", "Eurasiatica", ALTERNATIVE_SUBCARDS),
    ("giulia", "Vento dell'Ovest", "Panamericana", BEST_SUBCARDS),
    ("luca", "Lama d'Oriente", "Euroatlantica", ALTERNATIVE_SUBCARDS),
]


def call(method, path, body=None, token=None):
    request = urllib.request.Request(API + path, method=method,
                                     data=json.dumps(body).encode() if body is not None else None)
    request.add_header("Content-Type", "application/json")
    if token:
        request.add_header("Authorization", "Bearer " + token)
    try:
        with urllib.request.urlopen(request) as response:
            raw = response.read()
            return response.status, json.loads(raw) if raw else None
    except urllib.error.HTTPError as error:
        return error.code, None


def login(nickname):
    status, _ = call("POST", "/auth/register",
                     {"nickname": nickname, "email": f"{nickname}@fighters.demo", "password": PASSWORD})
    if status not in (201, 409):
        raise SystemExit(f"Registration of {nickname} failed with HTTP {status}")
    status, body = call("POST", "/auth/login", {"email": f"{nickname}@fighters.demo", "password": PASSWORD})
    if status != 200:
        raise SystemExit(f"Login of {nickname} failed with HTTP {status}")
    return body["accessToken"]


def ensure_deck(token, name, faction, subcards):
    _, decks = call("GET", "/me/decks", token=token)
    existing = next((deck for deck in decks if deck["name"] == name), None)
    if existing:
        return existing["id"]
    _, page = call("GET", "/me/collection?size=100", token=token)
    owned = [card for card in page["content"] if card["faction"] == faction]
    picked = [card for card in owned if card["rarity"] == "Rara"][:2]
    picked += [card for card in owned if card["rarity"] == "Comune"][:8]
    cards = [{"cardId": card["cardId"], "copies": 1,
              "subcards": subcards[card["fighterClass"]][:SLOTS[card["rarity"]]]} for card in picked]
    status, deck = call("POST", "/me/decks", {"name": name, "cards": cards}, token)
    if status != 201:
        raise SystemExit(f"Deck {name} rejected with HTTP {status}")
    return deck["id"]


def play(challenger, opponent, mode):
    _, match = call("POST", "/matches", {"opponentNickname": opponent["nickname"],
                                         "deckId": challenger["deck"], "mode": mode}, challenger["token"])
    call("POST", f"/matches/{match['id']}/accept", {"deckId": opponent["deck"]}, opponent["token"])


def main():
    players = {}
    for nickname, deck_name, faction, subcards in PLAYERS:
        token = login(nickname)
        players[nickname] = {"nickname": nickname, "token": token,
                             "deck": ensure_deck(token, deck_name, faction, subcards)}
    sara, marco, giulia, luca = (players[name] for name in ("sara", "marco", "giulia", "luca"))
    _, history = call("GET", "/matches/history", token=sara["token"])
    if not history["content"]:
        play(sara, marco, "BASE")
        play(sara, marco, "ADVANCED")
        play(giulia, luca, "ADVANCED")
    _, requests = call("GET", "/me/friends/requests", token=sara["token"])
    _, friends = call("GET", "/me/friends", token=sara["token"])
    if requests is not None and not requests["outgoing"] and not friends:
        call("POST", "/me/friends/requests", {"nickname": "marco"}, sara["token"])
    print("Demo players ready: sara, marco, giulia, luca (@fighters.demo, password " + PASSWORD + ")")


if __name__ == "__main__":
    main()
