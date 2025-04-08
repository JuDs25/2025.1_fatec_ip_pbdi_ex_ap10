-- 1.1 Resolva cada exercício a seguir usando LOOP, WHILE, FOR e FOREACH. Quando o 
-- enunciado disser que é preciso “ler” algum valor, gere-o aleatoriamente.

--  Explicação de cada estrutura de repetição (LOOP, WHILE, FOR, FOREACH) 
-- LOOP -> Não tem condição embutida, necessário controlar o fluxo manualmente com EXIT WHEN.
-- WHERE (enquanto) -> Roda enquanto a condição for verdadeira. Checa a condição antes de cada iteração.
-- FOR -> Controlado por um contador com valor inicial e final definidos.
-- FOREACH -> Usado para percorrer todos os elementos de um array.

-- Criando a função de valor aleatório
CREATE OR REPLACE FUNCTION valor_aleatorio_entre (lim_inferior INT, lim_superior
 INT) RETURNS INT AS
 $$
 BEGIN
 RETURN FLOOR(RANDOM() * (lim_superior - lim_inferior + 1) + lim_inferior)::INT;
 END;
 $$ LANGUAGE plpgsql;

-- Exercício 1 — Mostrar todos os números pares de 1 a 100
-- Usando LOOP 
DO $$
DECLARE
    num INT := 1;
BEGIN
    LOOP
        EXIT WHEN num > 100; -- parada
        IF num % 2 = 0 THEN -- condição de número par
            RAISE NOTICE '%', num;
        END IF;
        num := num + 1; -- contador
    END LOOP;
END 
$$;
-- Usando WHERE
DO $$
DECLARE
    num INT := 1;
BEGIN
    WHILE num <= 100 LOOP -- condição de continuidade (enquanto)
        IF num % 2 = 0 THEN
            RAISE NOTICE '%', num;
        END IF;
        num := num + 1;
    END LOOP;
END 
$$;
-- Usando FOR
DO $$
DECLARE
    num INT;
BEGIN
    FOR num IN 1..100 LOOP -- similar ao for i in range, mas diferente do python o último número é incluso
        IF num % 2 = 0 THEN
            RAISE NOTICE '%', num;
        END IF;
    END LOOP;
END 
$$;

-- Usando FOREACH 
DO $$
DECLARE
    arrayNum INT[] := '{}'; -- vazio
    num INT;
    numItera INT;
BEGIN
    -- Preenchendo o array manualmente com FOR
    FOR num IN 1..100 LOOP
        arrayNum  := array_append(arrayNum , num);
           -- RAISE NOTICE '%', arrayNum;    
    END LOOP;
    -- Iterando com FOREACH
    FOREACH numItera IN ARRAY arrayNum  LOOP
        IF numItera % 2 = 0 THEN
            RAISE NOTICE '%', numItera;
        END IF;
    END LOOP;
END 
$$;
-- Exercício 2 — Mostrar quanto dos 6 números gerados aleatoriamente entre -50 e 50 são positivos.
-- Usando LOOP
DO $$
DECLARE
    num INT := 1;
    valor INT;
    positivo INT := 0;
BEGIN
    LOOP
        EXIT WHEN num > 6;
        valor := valor_aleatorio_entre(-50, 50);
        RAISE NOTICE 'Valor %: %', num, valor;
        IF valor > 0 THEN
            positivo := positivo + 1;
        END IF;
        num := num + 1;
    END LOOP;
    RAISE NOTICE 'Positivos encontrados: %', positivo;
END 
$$;
-- Usando WHILE
DO $$
DECLARE
    num INT := 1;
    valor INT;
    positivo INT := 0;
BEGIN
    WHILE num <= 6 LOOP
        valor := valor_aleatorio_entre(-50, 50);
        RAISE NOTICE 'Valor %: %', num, valor;
        IF valor > 0 THEN
            positivo := positivo + 1;
        END IF;
        num := num + 1;
    END LOOP;
    RAISE NOTICE 'Positivos encontrados: %', positivo;
END 
$$;
-- Usando FOR
DO $$
DECLARE
    num INT := 1;
    valor INT;
    positivo INT := 0;
BEGIN
    FOR num IN 1..6 LOOP
        valor := valor_aleatorio_entre(-50, 50);
        RAISE NOTICE 'Valor %: %', num, valor;
        IF valor > 0 THEN
            positivo := positivo + 1;
        END IF;
    END LOOP;
    RAISE NOTICE 'Positivos encontrados: %', positivo;
END 
$$;
-- Usando FOREACH
DO $$
DECLARE
    num INT [] := '{}';
    valor INT;
    positivo INT := 0;
    numArray INT;
BEGIN
-- automatiza o preenchimento do array
    FOR numArray IN 1..6 LOOP
        num := array_append(num, valor_aleatorio_entre(-50, 50));
    END LOOP;

    FOREACH valor IN ARRAY num LOOP
        RAISE NOTICE 'Valor: %', valor;
        IF valor > 0 THEN
            positivo := positivo + 1;
        END IF;
    END LOOP;
    RAISE NOTICE 'Positivos encontrados: %', positivo;
END 
$$;
-- Exercício 3 - Leia 2 valores inteiros X e Y. A seguir, calcule e mostre a soma dos números ímpares entre eles.
-- O valor menor entre X e Y inclusive não deve entrar na soma, assim como o maior também não entra.
-- Usando LOOP
DO $$
DECLARE
    x INT := valor_aleatorio_entre(20, 50);
    y INT := valor_aleatorio_entre(20, 50);
    inicio INT;
    fim INT;
    soma INT := 0;
BEGIN
    IF x < y THEN
        inicio := x + 1;
        fim := y - 1;
    ELSE
        inicio := y + 1;
        fim := x - 1;
    END IF;
    RAISE NOTICE 'Valores sorteados: x = %, y = %', x, y;
    LOOP
        EXIT WHEN inicio > fim;
        IF inicio % 2 <> 0 THEN -- valida ímpar
            soma := soma + inicio;
        END IF;
        inicio := inicio + 1;
    END LOOP;
    RAISE NOTICE 'Soma dos ímpares: %', soma;
END 
$$;

-- Usando While
DO $$
DECLARE
    x INT := valor_aleatorio_entre(20, 50);
    y INT := valor_aleatorio_entre(20, 50);
    inicio INT;
    fim INT;
    soma INT := 0;
BEGIN
-- Verifica qual dos dois valores sorteados é o menor
    IF x < y THEN
    -- Se x for menor, começamos no valor logo após x e vamos até antes de y
        inicio := x + 1;
        fim := y - 1;
    -- Se y for menor, começamos no valor logo após y e vamos até antes de x
    ELSE
        inicio := y + 1;
        fim := x - 1;
    END IF;

    RAISE NOTICE 'Valores sorteados: x = %, y = %', x, y;

    WHILE inicio <= fim LOOP
        IF inicio % 2 <> 0 THEN -- valida ímpar
            soma := soma + inicio;
        END IF;
        inicio := inicio + 1;
    END LOOP;
    RAISE NOTICE 'Soma dos ímpares: %', soma;
END
$$;

-- Usando FOR 
DO $$
DECLARE
    x INT := valor_aleatorio_entre(20, 50);
    y INT := valor_aleatorio_entre(20, 50);
    inicio INT;
    fim INT;
    soma INT := 0;
    i INT; -- contador do FOR
BEGIN
-- Verifica qual dos dois valores sorteados é o menor
    IF x < y THEN
    -- Se x for menor, começamos no valor logo após x e vamos até antes de y
        inicio := x + 1;
        fim := y - 1;
    -- Se y for menor, começamos no valor logo após y e vamos até antes de x
    ELSE
        inicio := y + 1;
        fim := x - 1;
    END IF;

    RAISE NOTICE 'Valores sorteados: x = %, y = %', x, y;

    FOR i IN inicio..fim LOOP
        IF i % 2 <> 0 THEN -- valida ímpar
            soma := soma + i;
        END IF;
    END LOOP;
    RAISE NOTICE 'Soma dos ímpares: %', soma;
END
$$;
-- Usando FOREACH
DO $$
DECLARE
    x INT := valor_aleatorio_entre(20, 50);
    y INT := valor_aleatorio_entre(20, 50);
    inicio INT;
    fim INT;
    soma INT := 0;
    numeros INT[] := '{}';  -- array que vai conter os números entre x e y
    n INT;  -- elemento atual do array
BEGIN
-- Verifica qual dos dois valores sorteados é o menor
    IF x < y THEN
    -- Se x for menor, começamos no valor logo após x e vamos até antes de y
        inicio := x + 1;
        fim := y - 1;
    -- Se y for menor, começamos no valor logo após y e vamos até antes de x
    ELSE
        inicio := y + 1;
        fim := x - 1;
    END IF;
    RAISE NOTICE 'Valores sorteados: x = %, y = %', x, y;

    -- Preenche o array com os números entre x e y
    FOR i IN inicio..fim LOOP
        numeros := array_append(numeros, i);
    END LOOP;

    -- Itera sobre o array com FOREACH
    FOREACH n IN ARRAY numeros LOOP
        IF n % 2 <> 0 THEN  -- verifica se é ímpar
            soma := soma + n;
        END IF;
    END LOOP;

    RAISE NOTICE 'Soma dos ímpares: %', soma;
END 
$$;
-- Exercício 4 - Leia pares de valores M e N.
-- Para cada par, imprima a sequência do menor para o maior (inclusive) e a soma dos valores.
-- O programa deve encerrar quando M ≤ 0 ou N ≤ 0.

-- Usando LOOP
DO $$
DECLARE
    m INT;
    n INT;
    inicio INT;
    fim INT;
    i INT;
    soma INT;
BEGIN
    LOOP
        -- Gera dois valores aleatórios
        m := valor_aleatorio_entre(-5, 100);  -- permite que o loop pare eventualmente
        n := valor_aleatorio_entre(1, 100);

        -- Verifica condição de parada
        EXIT WHEN m <= 0 OR n <= 0;

        -- Define início e fim com base no menor e maior valor
        IF m < n THEN
            inicio := m;
            fim := n;
        ELSE
            inicio := n;
            fim := m;
        END IF;

        soma := 0;
        RAISE NOTICE 'Par gerado: M = %, N = %', m, n;

        i := inicio;
        LOOP
            EXIT WHEN i > fim;

            soma := soma + i;
            RAISE NOTICE '% ', i;

            i := i + 1;
        END LOOP;
        RAISE NOTICE 'Soma = %', soma;
    END LOOP;
END 
$$;

-- Usando While

DO $$
DECLARE
    m INT;
    n INT;
    inicio INT;
    fim INT;
    i INT;
    soma INT;
    contador INT := 1;
BEGIN
    -- Limitando para no máximo 5 execuções com possibilidade de parar antes
    WHILE contador <= 5 LOOP
        m := valor_aleatorio_entre(-5, 100);  -- pode sortear valor <= 0
        n := valor_aleatorio_entre(1, 100);

        -- Verifica condição de parada
        EXIT WHEN m <= 0 OR n <= 0;

        IF m < n THEN
            inicio := m;
            fim := n;
        ELSE
            inicio := n;
            fim := m;
        END IF;

        soma := 0;
        RAISE NOTICE 'Par gerado: M = %, N = %', m, n;

        i := inicio;
        WHILE i <= fim LOOP
            soma := soma + i;
            RAISE NOTICE '% ', i;
            i := i + 1;
        END LOOP;

        RAISE NOTICE 'Soma = %', soma;

        contador := contador + 1;
    END LOOP;
END 
$$;

-- Usando FOR
DO $$
DECLARE
    m INT;
    n INT;
    menor INT;
    maior INT;
    soma INT;
    i INT;
BEGIN
    -- Vamos simular 5 pares (o último com zero para encerrar)
    FOR cont IN 1..5 LOOP
        -- Geração dos valores aleatórios
        IF cont = 5 THEN
            m := 0;  -- força a condição de parada
            n := valor_aleatorio_entre(1, 100);
        ELSE
            m := valor_aleatorio_entre(1, 100);
            n := valor_aleatorio_entre(1, 100);
        END IF;

        -- Verifica condição de parada
        EXIT WHEN m <= 0 OR n <= 0;

        -- Define limites do intervalo
        IF m < n THEN
            menor := m;
            maior := n;
        ELSE
            menor := n;
            maior := m;
        END IF;

        soma := 0;
        RAISE NOTICE 'Par gerado: M = %, N = %', m, n;

        FOR i IN menor..maior LOOP
            soma := soma + i;
            RAISE NOTICE '% ', i;
        END LOOP;

        RAISE NOTICE 'Soma = %', soma;
    END LOOP;
END 
$$;

-- Usando FOREACH
DO $$
DECLARE
    pares INT[][] := ARRAY[
        [valor_aleatorio_entre(1, 100), valor_aleatorio_entre(1, 100)],
        [valor_aleatorio_entre(1, 100), valor_aleatorio_entre(1, 100)],
        [valor_aleatorio_entre(1, 100), valor_aleatorio_entre(1, 100)],
        [valor_aleatorio_entre(1, 100), valor_aleatorio_entre(1, 100)],
        [0, valor_aleatorio_entre(1, 100)]  -- força parada
    ];
    par INT[];
    m INT;
    n INT;
    menor INT;
    maior INT;
    soma INT;
    i INT;
BEGIN
    FOREACH par SLICE 1 IN ARRAY pares LOOP
        m := par[1];
        n := par[2];

        EXIT WHEN m <= 0 OR n <= 0;

        -- Define o intervalo ordenado
        IF m < n THEN
            menor := m;
            maior := n;
        ELSE
            menor := n;
            maior := m;
        END IF;

        soma := 0;
        RAISE NOTICE 'Par gerado: M = %, N = %', m, n;

        FOR i IN menor..maior LOOP
            soma := soma + i;
            RAISE NOTICE '% ', i;
        END LOOP;

        RAISE NOTICE 'Soma = %', soma;
    END LOOP;
END 
$$;


-- 2.2 - Faça um programa que calcule o determinante de uma matriz quadrada de ordem 3
-- utilizando a regra de Sarrus. 
-- Preencha a matriz com valores inteiros aleatórios no intervalo de 1 a 12.
DO $$
DECLARE
    matriz INT[3][3] := ARRAY[
        [valor_aleatorio_entre(1, 12), valor_aleatorio_entre(1, 12), valor_aleatorio_entre(1, 12)],
        [valor_aleatorio_entre(1, 12), valor_aleatorio_entre(1, 12), valor_aleatorio_entre(1, 12)],
        [valor_aleatorio_entre(1, 12), valor_aleatorio_entre(1, 12), valor_aleatorio_entre(1, 12)]
    ];
    det INT;
BEGIN
    RAISE NOTICE 'Matriz 3x3:';
    FOR i IN 1..3 LOOP
        RAISE NOTICE '% % %', matriz[i][1], matriz[i][2], matriz[i][3];
    END LOOP;

    -- Aplicando a regra de Sarrus
    det := (
        matriz[1][1] * matriz[2][2] * matriz[3][3] +
        matriz[1][2] * matriz[2][3] * matriz[3][1] +
        matriz[1][3] * matriz[2][1] * matriz[3][2]
    ) - (
        matriz[1][3] * matriz[2][2] * matriz[3][1] +
        matriz[1][1] * matriz[2][3] * matriz[3][2] +
        matriz[1][2] * matriz[2][1] * matriz[3][3]
    );
    RAISE NOTICE 'Determinante da matriz: %', det;
END 
$$;
