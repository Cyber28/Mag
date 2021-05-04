# Mag

Mag (Hungarian: seed) is a small API to generate [filtered seeds](https://docs.google.com/spreadsheets/d/1ilu72GJ-vJZq2LFU68rycGMeTbWPjHJnO8PGfp4QjA8) for various purposes

## Example usage

`GET http://localhost:port/village-plus-plus`
```json
{
  "cached": true,
  "seed": -4355852075190131575,
  "took": 14972
}
```

## Currently supported generators

| Supported Generators | Endpoints |
| --- | --- |
| [fsg-power-village-plusplus](https://replit.com/@AndyNovo/fsg-power-village-plusplus) | `/village-plus-plus` |

## Response types

`/:generator-type`

```json
{
  "cached": boolean, // true if it was fetched from cache, false if cache was empty and it was generated upon request
  "seed": number, // the seed
  "took": number // time (in milliseconds) it took to generate the seed
}
```

## Deployment (without Docker)

**Requirements:**
- Some version of linux, as the generator executables are built for linux
- Elixir 11+ (should work)

`mix deps.get`
`mix run`

## Deployment (with Docker)

soon :)

## Extra details

- You can specify a port with the `MAG_PORT` environment variable (NOT IMPLEMENTED YET LOL)
- By default, Mag caches 10 seeds per generator. You can edit this number in the `lib/mag/cache.ex` file


### Credits

- Everyone involved in the filtered seed projects!
- [Cyber28](https://github.com/Cyber28) for writing this junk