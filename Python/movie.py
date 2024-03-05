import requests
import random
import config  # Import the config file

def get_data(type, year=None, genre=None, actor=None, trending=False):
    base_url = "https://api.themoviedb.org/3"
    url = f"{base_url}/discover/{type}?api_key={config.api_key}"

    if year:
        url += f"&primary_release_year={year}"
    if genre:
        url += f"&with_genres={genre}"
    if actor:
        url += f"&with_people={actor}"
    if trending:
        url = f"{base_url}/trending/{type}/week?api_key={config.api_key}"

    response = requests.get(url)
    data = response.json()

    return data.get("results", [])

def get_genre_id(genre_name):
    url = f"https://api.themoviedb.org/3/genre/movie/list?api_key={config.api_key}"
    response = requests.get(url)
    data = response.json()

    for genre in data['genres']:
        if genre['name'].lower() == genre_name.lower():
            return genre['id']

    return None

def get_actor_id(actor_name):
    url = f"https://api.themoviedb.org/3/search/person?api_key={config.api_key}&query={actor_name}"
    response = requests.get(url)
    data = response.json()

    if data['results']:
        return data['results'][0]['id']

    return None

def choose_data(data, num_suggestions=5):
    # Ensure there are enough results to choose from
    num_suggestions = min(len(data), num_suggestions)

    return random.sample(data, num_suggestions) if data else []

def main():
    type = input("Do you want a movie or a TV series? (movie/tv): ")
    year = input("Enter a year (or '.' to skip): ")
    genre = input("Enter a genre (or '.' to skip): ")
    actor = input("Enter an actor (or '.' to skip): ")
    trending = input("Do you want a trending movie or series? (yes/no): ")

    year = int(year) if year != "." else None
    genre = get_genre_id(genre) if genre != "." else None
    actor = get_actor_id(actor) if actor != "." else None
    trending = True if trending.lower() == "yes" else False

    data = get_data(type, year, genre, actor, trending)
    chosen_data = choose_data(data)

    for i, choice in enumerate(chosen_data, 1):
        if type.lower() == "movie":
            print(f"Suggestion {i}: {choice['title']}")
            print(f"Overview: {choice['overview']}\n")
        elif type.lower() == "tv":
            print(f"Suggestion {i}: {choice['name']}")
            print(f"Overview: {choice['overview']}\n")

if __name__ == "__main__":
    main()
