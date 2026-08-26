-- =========================================================
-- MARMITARIA QUENTINHA CASEIRA - SCHEMA SUPABASE
-- =========================================================

-- 1. TABELA DE CARDÁPIO
CREATE TABLE IF NOT EXISTS public.cardapio (
    id TEXT PRIMARY KEY,
    categoria TEXT NOT NULL,
    nome TEXT NOT NULL,
    descricao TEXT DEFAULT '',
    tipo TEXT DEFAULT 'direct',
    preco NUMERIC DEFAULT 0,
    sizes JSONB DEFAULT '[]'::jsonb,
    misturas JSONB DEFAULT '[]'::jsonb,
    image TEXT DEFAULT 'img/marmita_milanesa.jpg',
    disponivel BOOLEAN DEFAULT TRUE,
    ordem INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. TABELA DE PEDIDOS
CREATE TABLE IF NOT EXISTS public.pedidos (
    id BIGSERIAL PRIMARY KEY,
    cliente_nome TEXT NOT NULL,
    cliente_telefone TEXT NOT NULL,
    tipo_entrega TEXT NOT NULL,
    endereco TEXT,
    complemento TEXT,
    itens JSONB NOT NULL,
    subtotal NUMERIC NOT NULL,
    taxa_entrega NUMERIC DEFAULT 0,
    total NUMERIC NOT NULL,
    forma_pagamento TEXT NOT NULL,
    troco_para TEXT,
    status TEXT DEFAULT 'pendente',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. TABELA DE CONFIGURAÇÕES DA LOJA
CREATE TABLE IF NOT EXISTS public.loja_config (
    id TEXT PRIMARY KEY DEFAULT 'config_geral',
    whatsapp TEXT DEFAULT '5541985294063',
    pix_key TEXT DEFAULT '41985294063',
    delivery_fee NUMERIC DEFAULT 5.00,
    hora_abertura TEXT DEFAULT '11:00',
    hora_fechamento TEXT DEFAULT '14:30',
    dias_funcionamento JSONB DEFAULT '["seg","ter","qua","qui","sex","sab"]'::jsonb,
    status_modo TEXT DEFAULT 'auto',
    mensagem_fechado TEXT DEFAULT 'Estamos fechados no momento. Almoço de Seg a Sáb das 11h às 14h30!',
    evolution_api_url TEXT DEFAULT '',
    evolution_api_key TEXT DEFAULT 'Marmitaria2026!',
    evolution_instance TEXT DEFAULT 'marmitaria',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- HABILITAR RLS COM ACESSO TOTAL PARA ANON
ALTER TABLE public.cardapio ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pedidos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.loja_config ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public full access cardapio" ON public.cardapio;
CREATE POLICY "Public full access cardapio" ON public.cardapio FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public full access pedidos" ON public.pedidos;
CREATE POLICY "Public full access pedidos" ON public.pedidos FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public full access loja_config" ON public.loja_config;
CREATE POLICY "Public full access loja_config" ON public.loja_config FOR ALL USING (true) WITH CHECK (true);

-- HABILITAR SUPABASE REALTIME
ALTER PUBLICATION supabase_realtime ADD TABLE public.cardapio;
ALTER PUBLICATION supabase_realtime ADD TABLE public.pedidos;
ALTER PUBLICATION supabase_realtime ADD TABLE public.loja_config;

-- SEED / POPULAR ITENS INICIAIS DO CARDÁPIO
INSERT INTO public.cardapio (id, categoria, nome, descricao, tipo, preco, sizes, misturas, image, disponivel, ordem) VALUES
('frango_milanesa', 'marmitas', 'Filé de Frango à Milanesa', 'Filé de frango empanado super crocante e suculento. Acompanha arroz, feijão, purê de batata, farofa, macarrão e salada.', 'marmita_sizes', 15.00, '[{"id":"P","name":"Marmita P","desc":"Porção individual econômica","price":15.00,"available":true},{"id":"M","name":"Marmita M","desc":"Porção farta e reforçada","price":22.90,"popular":true,"available":true},{"id":"G","name":"Marmita G","desc":"Porção grande família","price":26.90,"available":true}]'::jsonb, '[]'::jsonb, 'img/marmita_milanesa.jpg', true, 1),

('frango_parmegiana', 'marmitas', 'Filé de Frango à Parmegiana', 'Filé de frango empanado coberto com molho de tomate caseiro e queijo derretido. Acompanha arroz, feijão, purê de batata, farofa, macarrão e salada.', 'marmita_sizes', 18.00, '[{"id":"P","name":"Marmita P","desc":"Porção individual","price":18.00,"available":true},{"id":"M","name":"Marmita M","desc":"Porção farta com bastante queijo","price":25.90,"popular":true,"available":true},{"id":"G","name":"Marmita G","desc":"Porção grande reforçada","price":29.90,"available":true}]'::jsonb, '[]'::jsonb, 'img/marmita_parmegiana.jpg', true, 2),

('frango_barbecue', 'marmitas', 'Filé de Frango Milanesa c/ Molho Barbecue', 'Filé de frango crocante finalizado com molho barbecue especial da casa. Acompanha arroz, feijão, purê de batata, farofa, macarrão e salada.', 'marmita_sizes', 16.00, '[{"id":"P","name":"Marmita P","desc":"Porção individual","price":16.00,"available":true},{"id":"M","name":"Marmita M","desc":"Porção farta","price":23.90,"popular":true,"available":true},{"id":"G","name":"Marmita G","desc":"Porção grande família","price":27.90,"available":true}]'::jsonb, '[]'::jsonb, 'img/marmita_barbecue.jpg', true, 3),

('omelete_queijo', 'marmitas', 'Marmita Omelete com Queijo', 'Omelete fofinho e temperado, recheado com queijo derretido. Acompanha arroz, feijão, purê de batata, farofa, macarrão e salada.', 'marmita_sizes', 15.00, '[{"id":"P","name":"Marmita P","desc":"Porção individual","price":15.00,"available":true},{"id":"M","name":"Marmita M","desc":"Porção farta","price":22.90,"popular":true,"available":true},{"id":"G","name":"Marmita G","desc":"Porção grande família","price":26.90,"available":true}]'::jsonb, '[]'::jsonb, 'img/marmita_omelete.jpg', true, 4),

('calabresa_acebolada', 'marmitas', 'Calabresa Acebolada', 'Calabresa defumada fatiada e dourada na chapa com cebola suculenta. Acompanha arroz, feijão, purê de batata, farofa, macarrão e salada.', 'marmita_sizes', 15.00, '[{"id":"P","name":"Marmita P","desc":"Porção individual","price":15.00,"available":true},{"id":"M","name":"Marmita M","desc":"Porção farta","price":22.90,"popular":true,"available":true},{"id":"G","name":"Marmita G","desc":"Porção grande família","price":26.90,"available":true}]'::jsonb, '[]'::jsonb, 'img/marmita_calabresa.jpg', true, 5),

('marmita_economica_10', 'marmita10', 'Marmita Econômica (350g)', 'Marmitinha de 350 gramas com arroz, feijão caseiro, farofa e 1 opção de mistura à sua escolha.', 'marmita_10', 10.00, '[]'::jsonb, '["Bistequinha", "Calabresa", "Omelete", "Linguiça Toscana"]'::jsonb, 'img/marmita_economica.jpg', true, 6),

('marmita_feijoada', 'feijoada', 'Marmita de Feijoada Completa', 'Feijão preto encorpado com courinho, paio, calabresa, costelinha defumada, carne suína e bacon. Acompanha vinagrete, torresmo crocante, couve, arroz e farofa.', 'marmita_sizes', 20.00, '[{"id":"P","name":"Marmita P","desc":"Porção individual","price":20.00,"available":true},{"id":"M","name":"Marmita M","desc":"Porção farta","price":25.00,"popular":true,"available":true},{"id":"G","name":"Marmita G","desc":"Porção grande família","price":30.00,"available":true}]'::jsonb, '[]'::jsonb, 'img/marmita_feijoada.jpg', true, 7),

('kit_feijoada_2p', 'feijoada', 'Kit Feijoada Completa (2 Pessoas)', 'Feijoada farta com courinho, paio, calabresa, costelinha defumada, carne suína e bacon. Acompanha porções generosas de vinagrete, torresmo pururuca, couve refogada, arroz e farofa.', 'direct', 50.00, '[]'::jsonb, '[]'::jsonb, 'img/kit_feijoada.jpg', true, 8),

('add_frango_milanesa', 'adicionais', 'Adicional: Filé de Frango à Milanesa', 'Filé crocante extra frito na hora', 'direct', 6.00, '[]'::jsonb, '[]'::jsonb, 'img/marmita_milanesa.jpg', true, 9),
('add_frango_parmegiana', 'adicionais', 'Adicional: Filé de Frango à Parmegiana', 'Filé à parmegiana extra com molho e queijo', 'direct', 8.00, '[]'::jsonb, '[]'::jsonb, 'img/marmita_parmegiana.jpg', true, 10),
('add_calabresa', 'adicionais', 'Adicional: Calabresa Acebolada', 'Porção extra de calabresa com cebola', 'direct', 7.00, '[]'::jsonb, '[]'::jsonb, 'img/marmita_calabresa.jpg', true, 11),
('porcao_torresmo', 'adicionais', 'Porção de Torresmo Pururuca (250g)', 'Torresminho crocante e sequinho', 'direct', 18.00, '[]'::jsonb, '[]'::jsonb, 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=400&q=80', true, 12),
('porcao_fritas', 'adicionais', 'Porção de Batata Frita Crocante (350g)', 'Fritas douradas e sequinhas', 'direct', 16.00, '[]'::jsonb, '[]'::jsonb, 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&q=80', true, 13),
('ovo_frito', 'adicionais', 'Ovo Frito na Manteiga (Extra)', 'Gema mole ou no ponto desejado', 'direct', 3.50, '[]'::jsonb, '[]'::jsonb, 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&q=80', true, 14),

('cini_200ml', 'bebidas', 'Refrigerante Cini 200 ml', 'O clássico refrigerante paranaense bem gelado', 'direct', 4.00, '[]'::jsonb, '[]'::jsonb, 'img/cini200ml.jfif', true, 15),
('guarana_200ml', 'bebidas', 'Guaraná Antarctica 200 ml', 'O tradicional guaraná geladinho (200ml)', 'direct', 5.00, '[]'::jsonb, '[]'::jsonb, 'img/guarana200ml.png', true, 16),
('kuat_2l', 'bebidas', 'Refrigerante Kuat 2 Litros', 'Garrafa 2L geladíssima para a família', 'direct', 13.00, '[]'::jsonb, '[]'::jsonb, 'img/kuat2litros.png', true, 17),
('coca_2l', 'bebidas', 'Coca-Cola 2 Litros', 'Garrafa 2L super gelada', 'direct', 14.00, '[]'::jsonb, '[]'::jsonb, 'img/cocacola2litros.jfif', true, 18),
('agua_mineral', 'bebidas', 'Água Mineral 500ml', 'Com ou sem gás geladinha', 'direct', 3.50, '[]'::jsonb, '[]'::jsonb, 'img/agua_mineral_500ml.jfif', true, 19)
ON CONFLICT (id) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    tipo = EXCLUDED.tipo,
    preco = EXCLUDED.preco,
    sizes = EXCLUDED.sizes,
    misturas = EXCLUDED.misturas,
    image = EXCLUDED.image,
    disponivel = EXCLUDED.disponivel,
    ordem = EXCLUDED.ordem,
    updated_at = NOW();
