# Marmitaria Quentinha Caseira - Guia Completo de Operacao e Arquitetura

Este documento serve como referencia absoluta para qualquer agente de IA (como **kiro-cli** ou **antigravity**) operar, debugar, manter e evoluir o sistema da **Marmitaria Quentinha Caseira**.

---

## 1. Visao Geral do Ecossistema

* **Cliente / Dono da Loja**: "Negao" (Marmitaria em Curitiba/Xaxim).
* **Repositorio Git Principal**: `C:\Temp\AI_Agents\Personal\Marmitaria`
* **GitHub Remoto**: `https://github.com/stamarus/marmitaria-quentinha.git` (`main` branch)
* **Frontend Cliente**: `index.html` (Cardapio digital mobile-first, carrinho, calculo de entrega por CEP, checkout com envio para WhatsApp).
* **Dashboard Administrativo**: `dashboard.html` (Gestao em tempo real de pedidos, cardapio, guarnicoes, misturas, tamanhos, precos, horario de funcionamento e relatorios).
* **Infraestrutura Cloud**: Oracle Cloud Infrastructure (VM Ubuntu 24.04 ARM64) + Supabase (PostgreSQL Gerenciado).

---

## 2. Banco de Dados (Supabase PostgreSQL)

* **Host / Pooler**: `aws-0-sa-east-1.pooler.supabase.com:5432`
* **Database / Project ID**: `drecypzvptgyfltjlebh`
* **Usuario**: `postgres.drecypzvptgyfltjlebh`
* **Senha**: `M4rm1t4r14!2026`
* **URL de Conexao Python**:
  ```python
  import psycopg2
  conn = psycopg2.connect("postgresql://postgres.drecypzvptgyfltjlebh:M4rm1t4r14!2026@aws-0-sa-east-1.pooler.supabase.com:5432/postgres?sslmode=require")
  ```

### Tabelas Principais:

1. **`cardapio`**:
   * `id` (text, PK): ex. `frango_milanesa`, `item_1788211311570`.
   * `categoria` (text): `marmitas`, `marmita10`, `feijoada`, `adicionais`, `bebidas`, `guarnicoes`.
   * `nome` (text), `descricao` (text), `tipo` (text: `marmita_sizes`, `marmita_10`, `direct`).
   * `preco` (numeric): Preco base ou unitario.
   * `sizes` (jsonb): Array de tamanhos para marmitas tradicionais `[{"id":"P","name":"Marmita P","price":15.0,"available":true}, ...]`.
   * `misturas` (jsonb): Array de misturas para marmita de 10 `[{"name":"Bisteca Suina","available":true}, {"name":"Calabresa Acebolada","available":false}, ...]`.
   * `image` (text): URL ou caminho relativo (ex. `watermarked_img_...jpg`, `data:image/jpeg;base64,...`).
   * `disponivel` (boolean): `true` = ativo, `false` = prato pausado/esgotado no dia.
   * `ordem` (integer): Posicao de ordenacao no cardapio.

2. **`loja_config` & `lojas`**:
   * Horarios de funcionamento (segunda a sabado, 10:30 as 14:30), status manual (aberto/fechado), raio de entrega, taxas.

3. **`pedidos`**:
   * `id` (serial PK), `cliente_nome`, `cliente_telefone`, `tipo_entrega` (`delivery`/`retirada`), `endereco`, `itens` (jsonb), `subtotal`, `taxa_entrega`, `total`, `forma_pagamento`, `status` (`pendente`, `preparando`, `entrega`, `finalizado`, `cancelado`).

4. **`bug_reports`**:
   * Historico de pedidos de alteracao e bugs reportados pelo Negao.
   * `bug_id`, `bug_date`, `bug_desc`, `status` (`open`/`resolved`), `resolvido` (`YES`/`NO`), `bug_fix_date`.

---

## 3. Padroes de Codigo e UI/UX

* **Design**: Tailwind CSS via CDN + Lucide Icons. Tons quentes (`brand-700` vermelho terra / warm colors).
* **Tempo Real**: Tanto o cardapio quanto o dashboard escutam canais Supabase Realtime (`postgres_changes` em `cardapio`, `pedidos`, `loja_config`).
* **Granularidade de Disponibilidade**:
  * **Prato inteiro**: `item.disponivel` (true/false).
  * **Tamanho especifico (P, M, G)**: `item.sizes[i].available` (true/false).
  * **Mistura especifica (Marmita 10)**: `item.misturas[i].available` (true/false).
  * **Guarnicao (Arroz, Feijao, Macarrao, etc.)**: `MENU_ITEMS.guarnicoes[i].disponivel` (true/false).

---

## 4. Regras Obrigatorias para Qualquer Modificacao

1. **Retrocompatibilidade de Dados**:
   * Ao manipular `sizes` ou `misturas`, suporte sempre arrays legados de strings (`['Bisteca', 'Omelete']`) e arrays de objetos (`[{name: 'Bisteca', available: true}]`).
2. **Validacao de Sintaxe (Regression Validation)**:
   * Antes de commitar, valide o parser HTML/JS (`python -c "from html.parser import HTMLParser; ..."`).
3. **Deploy Continuo**:
   * Sempre faca commit e push para a branch `main`:
     ```powershell
     cd C:\Temp\AI_Agents\Personal\Marmitaria
     git add dashboard.html index.html
     git commit -m "mensagem descritiva"
     git push origin main
     ```
4. **Comunicacao com o Usuario**:
   * Chamar SEMPRE o usuario de **Rafa**.
   * Respostas diretas, executivas, no maximo 5 a 10 linhas. Sem enrolacao.
