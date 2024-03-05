import requests
import random
import config  # Import the config file

def get_data(type, year=None, genre=None, actor=None, trending=False):
    url = f"https://api.themoviedb.org/3/discover/{type}?api_key={config.api_key}"

    if year:
        url += f"&primary_release_year={year}"
    if genre:
        url += f"&with_genres={genre}"
    if actor:
        url += f"&with_people={actor}"
    if trending:
        url = f"https://api.themoviedb.org/3/trending/{type}/week?api_key={config.api_key}"

    response = requests.get(url)
    data = response.json()

    return data["results"]

def choose_data(data):
    return random.choice(data)

def main():
    type = input("Do you want a movie or a TV series? (movie/tv): ")
    year = input("Enter a year (or '.' to skip): ")
    genre = input("Enter a genre (or '.' to skip): ")
    actor = input("Enter an actor (or '.' to skip): ")
    trending = input("Do you want a trending movie or series? (yes/no): ")

    year = int(year) if year != "." else None
    genre = genre if genre != "." else None
    actor = actor if actor != "." else None
    trending = True if trending.lower() == "yes" else False

    data = get_data(type, year, genre, actor, trending)
    chosen_data = choose_data(data)

    if type.lower() == "movie":
        print(f"You should watch: {chosen_data['title']}")
        print(f"Overview: {chosen_data['overview']}")
    elif type.lower() == "tv":
        print(f"You should watch: {chosen_data['name']}")
        print(f"Overview: {chosen_data['overview']}")

if __name__ == "__main__":
    main()