# FDD Reference Guide

## O que é Feature Driven Development (FDD)

FDD é uma metodologia ágil orientada a features. A ideia central é que todo desenvolvimento
de software pode ser decomposto em **features** — pequenas funções de valor para o cliente,
implementáveis em no máximo 2 semanas.

O FDD clássico tem 5 processos:
1. Develop an Overall Model
2. **Build a Feature List** ← foco desta skill
3. Plan by Feature
4. Design by Feature
5. Build by Feature

Esta skill cobre os processos 1 e 2: modelar o domínio e construir a feature list.

---

## Hierarquia FDD

```
Subject Area (domínio / área de negócio)
  └── Feature Set (agrupamento funcional)
        └── Feature (unidade atômica de valor)
```

### Subject Area
- Representa um domínio de negócio amplo
- Exemplos: Autenticação, Pagamentos, Notificações, Relatórios, Integrações
- Não é um módulo técnico — é uma área de negócio

### Feature Set
- Grupo de features relacionadas dentro de um domínio
- Representa uma capacidade funcional
- Exemplos dentro de "Pagamentos": Checkout, Reembolsos, Histórico de Transações
- Deve ser coeso: todas as features devem pertencer à mesma capacidade

### Feature
- Unidade mínima de valor para o cliente
- Implementável por um dev em menos de 2 semanas
- **Sintaxe obrigatória:** `[verbo] o [resultado] [de/para/por/com] um [objeto]`

---

## Sintaxe de features: guia prático

### Fórmula
```
<verbo de ação> + o/a + <resultado> + <preposição> + um/uma + <objeto>
```

### Exemplos corretos ✅
```
Registrar um novo usuário com e-mail e senha
Calcular o score de crédito de um solicitante
Notificar o responsável sobre uma tarefa atrasada
Exibir o histórico de transações de uma conta
Cancelar uma assinatura ativa pelo usuário
Gerar o relatório mensal de gastos de um time
Validar o CPF de um novo cadastro
Enviar o comprovante de pagamento por e-mail
```

### Anti-padrões ❌

| Errado | Por quê | Correto |
|--------|---------|---------|
| "CRUD de usuários" | Técnico, não orientado ao cliente | "Registrar um novo usuário", "Atualizar os dados de um usuário"... |
| "Sistema de login" | Feature Set, não Feature | Quebre em features menores |
| "Gerenciar pagamentos" | Vago e amplo demais | "Processar um pagamento com cartão de crédito" |
| "API de autenticação" | Técnico, orientado ao sistema | "Autenticar um usuário com token JWT" |
| "Dashboard" | Não expressa ação de valor | "Exibir o resumo financeiro do mês atual" |

---

## Como quebrar Feature Sets em Features

### Pense nas ações do usuário, não nas telas
Em vez de "Tela de perfil", pense:
- "Atualizar os dados pessoais de um usuário"
- "Alterar a senha de uma conta autenticada"
- "Fazer upload do avatar de um perfil"
- "Desativar uma conta pelo próprio usuário"

### Cada CRUD vira features separadas
Não escreva "CRUD de X". Cada operação é uma feature própria, com seu próprio valor:
- "Criar uma nova categoria de despesa"
- "Editar o nome de uma categoria existente"
- "Arquivar uma categoria sem excluir seus registros"
(Note: listagem geralmente não é feature — é parte de outras features)

### Identifique o ponto de vista
A feature deve fazer sentido para o usuário final, não para o dev:
- ❌ "Implementar webhook de pagamento"
- ✅ "Atualizar o status de um pedido após confirmação de pagamento"

---

## Prioridades MoSCoW

| Prioridade | Significado | Critério |
|------------|-------------|---------|
| `must` | Obrigatório | Sem isso o produto não funciona ou não pode ser lançado |
| `should` | Importante | Alto valor, mas pode ser lançado sem e adicionado logo depois |
| `could` | Desejável | Bom ter se houver capacidade — sem impacto crítico |
| `wont` | Fora desta versão | Explicitamente descartado agora, pode voltar no futuro |

**Dica:** se mais de 40% das features são `must`, o escopo provavelmente está inflado.

---

## Acceptance Criteria

Cada feature deve ter critérios verificáveis. Use o formato:
```
Dado [contexto], quando [ação], então [resultado esperado]
```

Exemplos:
```
- Dado um usuário não autenticado, quando ele submete e-mail e senha válidos,
  então recebe um token JWT válido por 24h
- Dado um token expirado, quando o usuário tenta acessar um recurso protegido,
  então recebe erro 401 e é redirecionado para o login
```

---

## Dependências entre features

Use o campo `dependencies` para registrar:
- **Feature → Feature**: `"F-001"` (a feature atual depende de F-001 estar pronta)
- **Feature → Feature Set**: `"FS-02-01"` (depende de toda a capacidade do FS)

Dependências circulares são um sinal de que a decomposição está errada — revise.

---

## Checklist de qualidade de uma feature list

Antes de finalizar, verifique:
- [ ] Toda feature expressa valor para o usuário (não técnico)
- [ ] Toda feature usa a sintaxe `verbo + resultado + objeto`
- [ ] Toda feature é implementável em ≤ 2 semanas
- [ ] Não há features duplicadas ou sobrepostas
- [ ] `must` representa ≤ 40% do total
- [ ] Todo `must` tem pelo menos 1 acceptance criterion
- [ ] Dependências estão registradas e não são circulares
- [ ] O que está em `wont` foi explicitamente alinhado com o usuário
