# CLAUDE

## Sobre o projeto

Nome: Ucs espaços

Descrição: Aplicativo web institucional para reservar espaços diversos nas dependências da Universidade de Caxias do Sul, como salas de aula, laboratórios, auditórios, etc.

O sistema possui dois ambientes: um para os usuários finais (alunos, professores, funcionários) e outro para os administradores (funcionários responsáveis por gerenciar as reservas e os espaços). Sendo o primeiro focado em usabilidade e simplicidade, e o segundo focado em funcionalidade e eficiência assim como um ERP.

## Stack

- Arquitetura: Layered Architecture (Client–Server)
- Framework: Next.js
- Origem dos dados: Django Rest Framework (API REST)
- Estilos: [Tailwind.js](https://tailwindcss.com/)
- Reatividade: [React.js](https://react.dev/), [React Query](https://react-query.tanstack.com/), [Zustand](https://zustand-demo.pmnd.rs/), [React Hook Form](https://react-hook-form.com/)
- Componentes:
  - [ShadCN](https://ui.shadcn.com/) - biblioteca de componentes baseada no design system do Radix UI e estilizada com Tailwind CSS
  - Componentes customizados desenvolvidos para atender às necessidades específicas do projeto
- Icones : [phosphor](https://phosphoricons.com/)

## Comandos uteis

- `yarn`: instala as dependências do projeto
- `yarn dev`: inicia o servidor de desenvolvimento
- `yarn build`: gera uma versão otimizada para produção
- `yarn start`: inicia o servidor de produção
- `yarn lint`: executa o linter para verificar a qualidade do código
- `yarn test`: executa os testes automatizados

## Critical Behavior Rules

- Do *not* hallucinate. If information is missing, unclear, or not present in the codebase, explicitly state that you don’t know.
- Do *not* infer or assume requirements beyond what was explicitly requested.
- If a task would require additional steps, changes, or decisions not clearly specified, *ask for confirmation before proceeding*.
- If a question or requirement is unresolved, ambiguous, or incomplete, *ask the user for clarification instead of guessing or deducing*.
- Prioritize correctness over completeness when context is insufficient.
