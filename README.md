# Mag

Mag (Hungarian: seed) is a small API to generate [filtered seeds](https://docs.google.com/spreadsheets/d/1ilu72GJ-vJZq2LFU68rycGMeTbWPjHJnO8PGfp4QjA8) for various purposes

## Example usage

`GET http://localhost:port/powervillage`
```json
{
  "cache_size": 5,
  "cache_status": true,
  "seed": -4712597063144166317,
  "took": 26509
}
```

## Response types

`/:generator-type`

```json
{
  "cache_size": "number, number of seeds in the cache",
  "cache_status": "boolean, true if it was fetched from cache, false if cache was empty and it was generated upon request",
  "seed": "number, the seed",
  "took": "number, time (in milliseconds) it took to generate the seed"
}
```

`/cache`

```json
{
  "generator_name": "number, number of seeds cached for this generator"
}
```

## Deployment (without Docker)

**Requirements:**
- Some version of Linux, as the generator executables are built for Linux
- Elixir 11+ (should work, too lazy to run tests)

#### Deploying
- Drop your generator executables in /generators (they must be built for Linux)
- `mix deps.get`
- `mix run`

## Deployment (with Docker)

- `docker build . -t mag:latest`
- `docker run mag:latest`

## Extra details

- You can specify a port with the `MAG_PORT` environment variable (by default it will listen on 8000)
- You can specify the number of seeds to keep cached with the `MAG_MAX_CACHE` environment variable (by default it will cache 10)
- You can specify the number of generator executables to run at once with the `MAG_MAX_GENERATORS` environment variable (by default it will run 1)
- It is HIGHLY recommended to only allow specified hosts to access your deployment

### Credits

- Everyone involved in the filtered seed projects!
- [Cyber28](https://github.com/Cyber28) for writing this junk
- [Ravy](https://ravy.pink) for helping with Docker support