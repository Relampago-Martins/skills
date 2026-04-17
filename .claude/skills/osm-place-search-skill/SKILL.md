---
name: osm-place-search
description: >
  Implementa busca de localização via OpenStreetMap (Nominatim) em projetos Next.js,
  substituindo inputs manuais de latitude/longitude por um search-select que preenche
  as coordenadas automaticamente. Use esta skill sempre que o usuário mencionar busca
  de endereço, autocomplete de localização, input de coordenadas, integração com
  OpenStreetMap ou Nominatim em projetos Next.js ou React.
---

# OSM Place Search — Next.js

Adiciona busca de lugares via **Nominatim (OpenStreetMap)** ao projeto. Sem API key.

Esta skill cobre apenas a **camada de busca**: Route Handler proxy + tipo de retorno.
A integração com componentes, forms e mapas fica a cargo do projeto — pergunte ao usuário como ele quer conectar antes de implementar.

## O que esta skill entrega

- `app/api/places/route.ts` — Route Handler que faz proxy para o Nominatim
- Tipo `NominatimPlace` para tipar o retorno da API

## Route Handler proxy

Proxiar pelo servidor evita CORS e centraliza o rate limit.

```ts
// app/api/places/route.ts
export async function GET(req: Request) {
  const { searchParams } = new URL(req.url);
  const q = searchParams.get("q");
  if (!q || q.length < 3) return Response.json([]);

  const params = new URLSearchParams({
    q,
    format: "json",
    addressdetails: "1",
    limit: "6",
    countrycodes: "br",
    "accept-language": "pt-BR",
  });

  const res = await fetch(
    `https://nominatim.openstreetmap.org/search?${params}`,
    {
      headers: {
        "User-Agent": `${process.env.APP_NAME ?? "MyApp"}/1.0 (${process.env.CONTACT_EMAIL ?? "dev@example.com"})`,
      },
      next: { revalidate: 60 },
    }
  );

  if (!res.ok) return Response.json([], { status: 502 });
  return Response.json(await res.json());
}
```

## Tipo de retorno

```ts
// types/place.ts  (ou onde o projeto organizar tipos)
export type NominatimPlace = {
  place_id: string;
  display_name: string;
  name?: string;
  lat: string;   // string — converter com +p.lat ao usar
  lon: string;
  address?: {
    city?: string;
    town?: string;
    state?: string;
    country?: string;
  };
};
```

Função de busca para usar no client:

```ts
async function searchPlaces(q: string): Promise<NominatimPlace[]> {
  if (q.length < 3) return [];
  const res = await fetch(`/api/places?q=${encodeURIComponent(q)}`);
  if (!res.ok) return [];
  return res.json();
}
```

## Variáveis de ambiente

Adicione ao `.env.local`:

```
APP_NAME=NomeDoProjeto
CONTACT_EMAIL=dev@example.com
```

## Regras do Nominatim

- Máximo **1 req/segundo** por IP — sempre usar debounce de ≥ 500ms no client
- `User-Agent` identificável é obrigatório em produção
- Não cachear resultados por mais de 24h
- Para uso intenso (> ~1 req/s sustentado), hospedar instância própria ou migrar para Geoapify (free tier generoso, mesma interface)