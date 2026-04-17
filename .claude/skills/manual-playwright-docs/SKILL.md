---
name: manual-playwright-docs
description: Gera manuais em Markdown com screenshots de fluxos web usando Playwright. Use quando o usuário pedir manual, guia passo a passo, documentação com imagens, onboarding de sistema, handoff operacional ou registro de fluxos navegáveis com Playwright.
---

# Manual Playwright Docs

## Objetivo

Criar manuais em Markdown com screenshots focadas em elementos relevantes da interface, organizados em uma sequência lógica e fáceis de manter.

Esta skill é genérica, mas utiliza este padrão:

- Saída em `docs/<slug-do-manual>/manual.md`
- Screenshots em `docs/<slug-do-manual>/screenshots/`

## Quando usar

Use esta skill quando o usuário pedir:

- manual do sistema
- guia do gestor, operador ou administrador
- documentação com screenshots
- passo a passo de fluxos web
- registro navegável de telas com Playwright

## Descoberta primeiro

Não comece navegando.

Primeiro, descubra o contexto do manual e monte um roteiro curto.

Antes de começar, confirme ou descubra:

1. Público do manual
2. Objetivo do material
3. URL(s) do sistema
4. Credenciais ou forma de autenticação
5. Fluxos que devem entrar no manual
6. Nível de profundidade esperado
7. Caminho de saída desejado, se o usuário tiver preferência

Se faltar contexto, faça perguntas curtas antes de navegar.

## Perguntas de contextualização

Quando o pedido vier genérico, faça de 4 a 6 perguntas curtas para alinhar:

- Quem vai usar este manual?
- O material é para operação, treinamento, apresentação ou handoff?
- Quais fluxos são obrigatórios?
- O que deve ficar de fora?
- O manual deve ser resumido ou detalhado?
- Existe um formato, pasta ou nomenclatura preferidos?

Se o usuário já tiver dado respostas suficientes, não repita perguntas.

## Roteiro antes da documentação

Antes de abrir o sistema, proponha um roteiro curto com:

1. Seções do manual
2. Fluxos que serão navegados
3. Tipos de screenshots esperadas
4. Ordem de execução

Use esse roteiro como contrato de trabalho.

Se o usuário ainda não tiver deixado o objetivo claro, peça aprovação do roteiro antes de navegar.

Se o contexto já estiver suficientemente claro, você pode seguir sem pausa explícita, mas ainda deve montar esse roteiro internamente e usá-lo para guiar a captura.

## Workflow

Copie este checklist e atualize conforme avança:

```md
Progresso do manual:
- [ ] Confirmar público, objetivo, URLs, login e escopo
- [ ] Fazer perguntas de contexto, se necessário
- [ ] Montar roteiro inicial do manual
- [ ] Validar roteiro com o usuário, quando necessário
- [ ] Criar pasta do manual e pasta de screenshots
- [ ] Entrar no sistema
- [ ] Validar o roteiro contra as telas reais
- [ ] Mapear telas e fluxos relevantes
- [ ] Capturar screenshots focadas
- [ ] Escrever o manual em Markdown
- [ ] Validar links das imagens e ordem lógica
```

## Fluxo condicional

Siga esta regra:

- Pedido com pouco contexto:
  - perguntar
  - montar roteiro
  - confirmar
  - documentar
- Pedido com contexto suficiente:
  - montar roteiro
  - navegar
  - documentar

Nunca pule direto para a documentação sem antes definir a narrativa do material.

## Navegação e captura

1. Use Playwright CLI para abrir o sistema, autenticar e navegar.
2. Primeiro entenda a estrutura da tela com `snapshot`.
3. Prefira screenshots de elemento.
4. Use screenshot de viewport apenas para:
   - visão geral da tela
   - contexto inicial de uma seção
   - telas em que o valor está no layout completo
5. Para destacar campos, tabelas, menus, filtros, cards ou painéis, capture apenas o bloco relevante.

## Regras de screenshot

- Uma screenshot deve ilustrar um ponto específico.
- Evite imagens redundantes.
- Prefira nomes sequenciais e descritivos:
  - `01-visao-geral.png`
  - `02-sidebar.png`
  - `03-tabela-itens.png`
- Mantenha a ordem dos arquivos igual à ordem de leitura do manual.
- Se houver dados sensíveis visíveis, pare e confirme com o usuário antes de documentar.

## Estrutura recomendada do manual

Na primeira página, inclua:

1. Título
2. Contexto curto
3. Sumário

Depois, organize por blocos lógicos:

1. Visão geral
2. Acesso
3. Navegação principal
4. Fluxos centrais por módulo
5. Referências rápidas, status ou observações finais

## Como usar o roteiro

O roteiro deve influenciar:

- a ordem das navegações
- a prioridade das capturas
- o nível de detalhamento do texto
- o que entra e o que fica fora do manual

Se o sistema real divergir do roteiro:

1. ajuste o roteiro
2. registre a diferença
3. não force o manual a seguir uma narrativa que a interface não sustenta

## Diretrizes de escrita

- Escreva para o público real do manual.
- Use linguagem operacional e direta.
- Explique o que o usuário vê, o que faz e o resultado esperado.
- Use tabelas quando ajudarem em estados, ações ou campos.
- Não invente comportamento que não foi observado.
- Se um fluxo não puder ser concluído, registre isso explicitamente no manual.

## Template de saída

Use o template em [template.md](template.md).

Adapte a profundidade conforme o sistema, mas mantenha:

- sumário no topo
- seções com títulos estáveis
- imagens próximas do texto que explicam
- ordem coerente entre navegação e documentação

## Validação final

Antes de encerrar:

1. Verifique se o roteiro foi refletido no manual final.
2. Confirme que o arquivo Markdown foi criado no diretório correto.
3. Confirme que todas as imagens existem.
4. Confira se os links relativos funcionam.
5. Garanta que o sumário esteja na primeira página.
6. Revise se há screenshots focadas o suficiente para servir como referência visual.

## Padrão preferencial deste projeto

Quando o usuário não indicar outro formato, use:

- arquivo principal: `docs/<slug>/manual.md`
- imagens: `docs/<slug>/screenshots/`
- nomes em português
- seções pensadas para operação de usuários de negócio
