-- Criação do Banco e Tabelas
CREATE DATABASE IF NOT EXISTS university;
USE university;

-- Tabelas
CREATE TABLE IF NOT EXISTS Area (
    id_area INT AUTO_INCREMENT PRIMARY KEY,
    nome_area VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Curso (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL,
    id_area INT,
    FOREIGN KEY (id_area) REFERENCES Area(id_area)
);

CREATE TABLE IF NOT EXISTS Aluno (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_nascimento DATE
);

CREATE TABLE IF NOT EXISTS Matricula (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT,
    id_curso INT,
    data_matricula DATE,
    FOREIGN KEY (id_aluno) REFERENCES Aluno(id_aluno),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso),
    UNIQUE (id_aluno, id_curso)
);

-- Stored Procedure para Inserir Cursos
DELIMITER //

CREATE PROCEDURE InserirCurso (
    IN nomeCurso VARCHAR(100),
    IN nomeArea VARCHAR(100)
)
BEGIN
    DECLARE idArea INT;
    
    SELECT id_area INTO idArea FROM Area WHERE nome_area = nomeArea LIMIT 1;
    
    IF idArea IS NULL THEN
        INSERT INTO Area (nome_area) VALUES (nomeArea);
        SET idArea = LAST_INSERT_ID();
    END IF;
    
    INSERT INTO Curso (nome_curso, id_area) VALUES (nomeCurso, idArea);
END //

DELIMITER ;

-- Função para Buscar o ID do Curso
DELIMITER //

CREATE FUNCTION BuscarIdCurso (
    nomeCurso VARCHAR(100),
    nomeArea VARCHAR(100)
) RETURNS INT
BEGIN
    DECLARE idCurso INT;

    SELECT c.id_curso
    INTO idCurso
    FROM Curso c
    JOIN Area a ON c.id_area = a.id_area
    WHERE c.nome_curso = nomeCurso AND a.nome_area = nomeArea
    LIMIT 1;

    RETURN idCurso;
END //

DELIMITER ;

-- Stored Procedure para Matricular Aluno
DELIMITER //

CREATE PROCEDURE MatricularAluno (
    IN nome VARCHAR(100),
    IN sobrenome VARCHAR(100),
    IN dataNascimento DATE,
    IN nomeCurso VARCHAR(100),
    IN nomeArea VARCHAR(100)
)
BEGIN
    DECLARE idAluno INT;
    DECLARE idCurso INT;
    DECLARE emailAluno VARCHAR(100);
    
    -- Cria o email do aluno
    SET emailAluno = CONCAT(LOWER(nome), '.', LOWER(sobrenome), '@dominio.com');
    
    -- Insere ou seleciona o aluno
    INSERT INTO Aluno (nome, sobrenome, email, data_nascimento)
    VALUES (nome, sobrenome, emailAluno, dataNascimento)
    ON DUPLICATE KEY UPDATE email=emailAluno;
    
    SET idAluno = LAST_INSERT_ID();
    
    -- Busca o ID do curso
    SET idCurso = BuscarIdCurso(nomeCurso, nomeArea);
    
    -- Verifica se o aluno já está matriculado no curso
    IF NOT EXISTS (SELECT 1 FROM Matricula WHERE id_aluno = idAluno AND id_curso = idCurso) THEN
        -- Matricula o aluno no curso
        INSERT INTO Matricula (id_aluno, id_curso, data_matricula) 
        VALUES (idAluno, idCurso, CURDATE());
    END IF;
END //

DELIMITER ;

-- Teste de Inserção e Busca de Curso
CALL InserirCurso('Engenharia de Software', 'Tecnologia');
CALL InserirCurso('Direito', 'Humanas');
CALL InserirCurso('Medicina', 'Saúde');

-- Testar a função de busca
SELECT BuscarIdCurso('Engenharia de Software', 'Tecnologia') AS 'ID Engenharia de Software';
SELECT BuscarIdCurso('Direito', 'Humanas') AS 'ID Direito';
SELECT BuscarIdCurso('Medicina', 'Saúde') AS 'ID Medicina';

-- Inserindo cursos
CALL InserirCurso('Engenharia de Software', 'Tecnologia');
CALL InserirCurso('Direito', 'Humanas');
CALL InserirCurso('Medicina', 'Saúde');
CALL InserirCurso('Administração', 'Negócios');
CALL InserirCurso('Psicologia', 'Ciências Sociais');
CALL InserirCurso('Engenharia Civil', 'Engenharia');
CALL InserirCurso('Arquitetura', 'Artes');
CALL InserirCurso('Biologia', 'Ciências Naturais');
CALL InserirCurso('Economia', 'Negócios');
CALL InserirCurso('Física', 'Ciências Exatas');
CALL InserirCurso('Química', 'Ciências Exatas');
CALL InserirCurso('História', 'Humanas');
CALL InserirCurso('Letras', 'Humanas');
CALL InserirCurso('Matemática', 'Ciências Exatas');
CALL InserirCurso('Filosofia', 'Humanas');
CALL InserirCurso('Sociologia', 'Ciências Sociais');
CALL InserirCurso('Educação Física', 'Educação');
CALL InserirCurso('Nutrição', 'Saúde');
CALL InserirCurso('Geografia', 'Ciências Sociais');
CALL InserirCurso('Computação', 'Tecnologia');
CALL InserirCurso('Artes Visuais', 'Artes');
CALL InserirCurso('Engenharia Elétrica', 'Engenharia');
CALL InserirCurso('Odontologia', 'Saúde');
CALL InserirCurso('Arqueologia', 'Humanas');
CALL InserirCurso('Ciência da Computação', 'Tecnologia');

-- Inserindo 200 alunos
CALL MatricularAluno('Luciana', 'Fernandes', '1990-01-26', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Ricardo', 'Almeida', '1991-02-27', 'Direito', 'Humanas');
CALL MatricularAluno('Fabiana', 'Santos', '1992-03-28', 'Medicina', 'Saúde');
CALL MatricularAluno('Gustavo', 'Silva', '1993-04-29', 'Administração', 'Negócios');
CALL MatricularAluno('Paula', 'Lima', '1994-05-30', 'Psicologia', 'Ciências Sociais');
CALL MatricularAluno('Roberto', 'Martins', '1995-06-01', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Andréia', 'Ferreira', '1996-07-02', 'Arquitetura', 'Artes');
CALL MatricularAluno('Maurício', 'Oliveira', '1997-08-03', 'Biologia', 'Ciências Naturais');
CALL MatricularAluno('Tatiane', 'Sousa', '1998-09-04', 'Economia', 'Negócios');
CALL MatricularAluno('José', 'Almeida', '1999-10-05', 'Física', 'Ciências Exatas');
CALL MatricularAluno('Caroline', 'Nascimento', '2000-11-06', 'Química', 'Ciências Exatas');
CALL MatricularAluno('Rodrigo', 'Santana', '2001-12-07', 'História', 'Humanas');
CALL MatricularAluno('Michele', 'Gomes', '2002-01-08', 'Letras', 'Humanas');
CALL MatricularAluno('Ronaldo', 'Martins', '2003-02-09', 'Matemática', 'Ciências Exatas');
CALL MatricularAluno('Monique', 'Ferreira', '2004-03-10', 'Filosofia', 'Humanas');
CALL MatricularAluno('Jorge', 'Sousa', '2005-04-11', 'Sociologia', 'Ciências Sociais');
CALL MatricularAluno('Márcia', 'Lima', '2006-05-12', 'Educação Física', 'Educação');
CALL MatricularAluno('Vinícius', 'Nascimento', '2007-06-13', 'Nutrição', 'Saúde');
CALL MatricularAluno('Fernanda', 'Santos', '2008-07-14', 'Geografia', 'Ciências Sociais');
CALL MatricularAluno('Leandro', 'Ferreira', '2009-08-15', 'Computação', 'Tecnologia');
CALL MatricularAluno('Marcela', 'Almeida', '2010-09-16', 'Artes Visuais', 'Artes');
CALL MatricularAluno('Eduardo', 'Martins', '2011-10-17', 'Engenharia Elétrica', 'Engenharia');
CALL MatricularAluno('Nathália', 'Oliveira', '2012-11-18', 'Odontologia', 'Saúde');
CALL MatricularAluno('Ricardo', 'Silva', '2013-12-19', 'Arqueologia', 'Humanas');
CALL MatricularAluno('Thaís', 'Sousa', '2014-01-20', 'Ciência da Computação', 'Tecnologia');
CALL MatricularAluno('Antônio', 'Nascimento', '2015-02-21', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Mariana', 'Martins', '2016-03-22', 'Direito', 'Humanas');
CALL MatricularAluno('Felipe', 'Ferreira', '2017-04-23', 'Medicina', 'Saúde');
CALL MatricularAluno('Aline', 'Silva', '2018-05-24', 'Administração', 'Negócios');
CALL MatricularAluno('Roberto', 'Santos', '2019-06-25', 'Psicologia', 'Ciências Sociais');
CALL MatricularAluno('Carolina', 'Lima', '2020-07-26', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Alexandre', 'Oliveira', '2021-08-27', 'Arquitetura', 'Artes');
CALL MatricularAluno('Bruna', 'Ferreira', '2022-09-28', 'Biologia', 'Ciências Naturais');
CALL MatricularAluno('Lucas', 'Martins', '2023-10-29', 'Economia', 'Negócios');
CALL MatricularAluno('Daniela', 'Silva', '2024-11-30', 'Física', 'Ciências Exatas');
CALL MatricularAluno('Marcelo', 'Sousa', '2025-12-31', 'Química', 'Ciências Exatas');
CALL MatricularAluno('Patricia', 'Sousa', '1995-01-01', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Felipe', 'Albuquerque', '1996-02-02', 'Direito', 'Humanas');
CALL MatricularAluno('Juliana', 'Fernandes', '1997-03-03', 'Medicina', 'Saúde');
CALL MatricularAluno('Lucas', 'Oliveira', '1998-04-04', 'Administração', 'Negócios');
CALL MatricularAluno('Ana', 'Lima', '1999-05-05', 'Psicologia', 'Ciências Sociais');
CALL MatricularAluno('Pedro', 'Santos', '2000-06-06', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Aline', 'Machado', '2001-07-07', 'Arquitetura', 'Artes');
CALL MatricularAluno('Rafael', 'Silva', '2002-08-08', 'Biologia', 'Ciências Naturais');
CALL MatricularAluno('Mariana', 'Ferreira', '2003-09-09', 'Economia', 'Negócios');
CALL MatricularAluno('Gabriel', 'Almeida', '2004-10-10', 'Física', 'Ciências Exatas');
CALL MatricularAluno('Laura', 'Pereira', '2005-11-11', 'Química', 'Ciências Exatas');
CALL MatricularAluno('Tiago', 'Costa', '2006-12-12', 'História', 'Humanas');
CALL MatricularAluno('Renata', 'Gomes', '2007-01-13', 'Letras', 'Humanas');
CALL MatricularAluno('Carolina', 'Martins', '2008-02-14', 'Matemática', 'Ciências Exatas');
CALL MatricularAluno('Marcos', 'Nascimento', '2009-03-15', 'Filosofia', 'Humanas');
CALL MatricularAluno('Laura', 'Souza', '2010-04-16', 'Sociologia', 'Ciências Sociais');
CALL MatricularAluno('Rafael', 'Lima', '2011-05-17', 'Educação Física', 'Educação');
CALL MatricularAluno('Fernanda', 'Mendes', '2012-06-18', 'Nutrição', 'Saúde');
CALL MatricularAluno('Carlos', 'Santana', '2013-07-19', 'Geografia', 'Ciências Sociais');
CALL MatricularAluno('Juliana', 'Ferreira', '2014-08-20', 'Computação', 'Tecnologia');
CALL MatricularAluno('Bruno', 'Costa', '2015-09-21', 'Artes Visuais', 'Artes');
CALL MatricularAluno('Maria', 'Oliveira', '2016-10-22', 'Engenharia Elétrica', 'Engenharia');
CALL MatricularAluno('José', 'Silva', '2017-11-23', 'Odontologia', 'Saúde');
CALL MatricularAluno('Ana', 'Almeida', '2018-12-24', 'Arqueologia', 'Humanas');
CALL MatricularAluno('Pedro', 'Machado', '2019-01-25', 'Ciência da Computação', 'Tecnologia');
CALL MatricularAluno('João', 'Silva', '1998-01-01', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Maria', 'Oliveira', '1999-02-15', 'Direito', 'Humanas');
CALL MatricularAluno('Pedro', 'Ferreira', '2000-03-20', 'Medicina', 'Saúde');
CALL MatricularAluno('Ana', 'Santos', '1997-04-10', 'Administração', 'Negócios');
CALL MatricularAluno('Lucas', 'Cunha', '1996-05-05', 'Psicologia', 'Ciências Sociais');
CALL MatricularAluno('Carla', 'Almeida', '1995-06-25', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Rafael', 'Mendes', '1994-07-30', 'Arquitetura', 'Artes');
CALL MatricularAluno('Mariana', 'Fernandes', '1993-08-12', 'Biologia', 'Ciências Naturais');
CALL MatricularAluno('Gabriel', 'Carvalho', '1992-09-08', 'Economia', 'Negócios');
CALL MatricularAluno('Patrícia', 'Rocha', '1991-10-17', 'Física', 'Ciências Exatas');
CALL MatricularAluno('Gustavo', 'Pereira', '1990-11-28', 'Química', 'Ciências Exatas');
CALL MatricularAluno('Aline', 'Martins', '1989-12-03', 'História', 'Humanas');
CALL MatricularAluno('Rodrigo', 'Gomes', '1988-01-14', 'Letras', 'Humanas');
CALL MatricularAluno('Vanessa', 'Dias', '1987-02-19', 'Matemática', 'Ciências Exatas');
CALL MatricularAluno('Fernando', 'Nascimento', '1986-03-25', 'Filosofia', 'Humanas');
CALL MatricularAluno('Jéssica', 'Souza', '1985-04-30', 'Sociologia', 'Ciências Sociais');
CALL MatricularAluno('Bruno', 'Lima', '1984-05-07', 'Educação Física', 'Educação');
CALL MatricularAluno('Juliana', 'Mendes', '1983-06-11', 'Nutrição', 'Saúde');
CALL MatricularAluno('Daniel', 'Ferreira', '1982-07-16', 'Geografia', 'Ciências Sociais');
CALL MatricularAluno('Carolina', 'Pinto', '1981-08-22', 'Computação', 'Tecnologia');
CALL MatricularAluno('Marcos', 'Costa', '1980-09-26', 'Artes Visuais', 'Artes');
CALL MatricularAluno('Laura', 'Oliveira', '1979-10-31', 'Engenharia Elétrica', 'Engenharia');
CALL MatricularAluno('Tiago', 'Santana', '1978-11-09', 'Odontologia', 'Saúde');
CALL MatricularAluno('Renata', 'Albuquerque', '1977-12-15', 'Arqueologia', 'Humanas');
CALL MatricularAluno('Felipe', 'Machado', '1976-01-20', 'Ciência da Computação', 'Tecnologia');
CALL MatricularAluno('Camila', 'Fernandes', '1990-01-26', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Renato', 'Almeida', '1991-02-27', 'Direito', 'Humanas');
CALL MatricularAluno('Mariana', 'Santos', '1992-03-28', 'Medicina', 'Saúde');
CALL MatricularAluno('Guilherme', 'Silva', '1993-04-29', 'Administração', 'Negócios');
CALL MatricularAluno('Isabela', 'Lima', '1994-05-30', 'Psicologia', 'Ciências Sociais');
CALL MatricularAluno('Vinícius', 'Martins', '1995-06-01', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Amanda', 'Ferreira', '1996-07-02', 'Arquitetura', 'Artes');
CALL MatricularAluno('Luciana', 'Oliveira', '1997-08-03', 'Biologia', 'Ciências Naturais');
CALL MatricularAluno('Ricardo', 'Goes', '1998-09-04', 'Economia', 'Negócios');
CALL MatricularAluno('Fernanda', 'Almeida', '1999-10-05', 'Física', 'Ciências Exatas');
CALL MatricularAluno('Gustavo', 'Nascimento', '2000-11-06', 'Química', 'Ciências Exatas');
CALL MatricularAluno('Paula', 'Santana', '2001-12-07', 'História', 'Humanas');
CALL MatricularAluno('Rodrigo', 'Gomes', '2002-01-08', 'Letras', 'Humanas');
CALL MatricularAluno('Patrícia', 'Martins', '2003-02-09', 'Matemática', 'Ciências Exatas');
CALL MatricularAluno('Thiago', 'Ferreira', '2004-03-10', 'Filosofia', 'Humanas');
CALL MatricularAluno('Daniela', 'Sousa', '2005-04-11', 'Sociologia', 'Ciências Sociais');
CALL MatricularAluno('Bruno', 'Lima', '2006-05-12', 'Educação Física', 'Educação');
CALL MatricularAluno('Juliana', 'Goes', '2007-06-13', 'Nutrição', 'Saúde');
CALL MatricularAluno('Alexandre', 'Santos', '2008-07-14', 'Geografia', 'Ciências Sociais');
CALL MatricularAluno('Márcio', 'Ferreira', '2009-08-15', 'Computação', 'Tecnologia');
CALL MatricularAluno('Nathália', 'Almeida', '2010-09-16', 'Artes Visuais', 'Artes');
CALL MatricularAluno('Larissa', 'Martins', '2011-10-17', 'Engenharia Elétrica', 'Engenharia');
CALL MatricularAluno('André', 'Oliveira', '2012-11-18', 'Odontologia', 'Saúde');
CALL MatricularAluno('Fabiana', 'Silva', '2013-12-19', 'Arqueologia', 'Humanas');
CALL MatricularAluno('Maurício', 'Sousa', '2014-01-20', 'Ciência da Computação', 'Tecnologia');
CALL MatricularAluno('Tatiane', 'Nascimento', '2015-02-21', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Leonardo', 'Martins', '2016-03-22', 'Direito', 'Humanas');
CALL MatricularAluno('Cristina', 'Ferreira', '2017-04-23', 'Medicina', 'Saúde');
CALL MatricularAluno('Rafaela', 'Silva', '2018-05-24', 'Administração', 'Negócios');
CALL MatricularAluno('Marcelo', 'Santos', '2019-06-25', 'Psicologia', 'Ciências Sociais');
CALL MatricularAluno('Diego', 'Lima', '2020-07-26', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Sabrina', 'Oliveira', '2021-08-27', 'Arquitetura', 'Artes');
CALL MatricularAluno('Raquel', 'Ferreira', '2022-09-28', 'Biologia', 'Ciências Naturais');
CALL MatricularAluno('Thales', 'Martins', '2023-10-29', 'Economia', 'Negócios');
CALL MatricularAluno('Carolina', 'Lima', '2024-11-30', 'Física', 'Ciências Exatas');
CALL MatricularAluno('Vinícius', 'Sousa', '2025-12-31', 'Química', 'Ciências Exatas');
CALL MatricularAluno('Renan', 'Fernandes', '1990-01-01', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Rafael', 'Almeida', '1991-02-02', 'Direito', 'Humanas');
CALL MatricularAluno('Juliana', 'Santos', '1992-03-03', 'Medicina', 'Saúde');
CALL MatricularAluno('Gustavo', 'Silva', '1993-04-04', 'Administração', 'Negócios');
CALL MatricularAluno('Isabela', 'Goes', '1994-05-05', 'Psicologia', 'Ciências Sociais');
CALL MatricularAluno('Vinícius', 'Martins', '1995-06-06', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Amanda', 'Goes', '1996-07-07', 'Arquitetura', 'Artes');
CALL MatricularAluno('Luciana', 'Oliveira', '1997-08-08', 'Biologia', 'Ciências Naturais');
CALL MatricularAluno('Ricardo', 'Sousa', '1998-09-09', 'Economia', 'Negócios');
CALL MatricularAluno('Fernanda', 'Almeida', '1999-10-10', 'Física', 'Ciências Exatas');
CALL MatricularAluno('Gustavo', 'Goes', '2000-11-11', 'Química', 'Ciências Exatas');
CALL MatricularAluno('Paula', 'Santana', '2001-12-12', 'História', 'Humanas');
CALL MatricularAluno('Rodrigo', 'Goes', '2002-01-13', 'Letras', 'Humanas');
CALL MatricularAluno('Patrícia', 'Martins', '2003-02-14', 'Matemática', 'Ciências Exatas');
CALL MatricularAluno('Thiago', 'Goes', '2004-03-15', 'Filosofia', 'Humanas');
CALL MatricularAluno('Daniela', 'Sousa', '2005-04-16', 'Sociologia', 'Ciências Sociais');
CALL MatricularAluno('Bruno', 'Goes', '2006-05-17', 'Educação Física', 'Educação');
CALL MatricularAluno('Juliana', 'Dias', '2007-06-18', 'Nutrição', 'Saúde');
CALL MatricularAluno('Alexandre', 'Goes', '2008-07-19', 'Geografia', 'Ciências Sociais');
CALL MatricularAluno('Márcio', 'Ferreira', '2009-08-20', 'Computação', 'Tecnologia');
CALL MatricularAluno('Nathália', 'Goes', '2010-09-21', 'Artes Visuais', 'Artes');
CALL MatricularAluno('Larissa', 'Martins', '2011-10-22', 'Engenharia Elétrica', 'Engenharia');
CALL MatricularAluno('André', 'Goes', '2012-11-23', 'Odontologia', 'Saúde');
CALL MatricularAluno('Fabiana', 'Silva', '2013-12-24', 'Arqueologia', 'Humanas');
CALL MatricularAluno('Maurício', 'Dias', '2014-01-25', 'Ciência da Computação', 'Tecnologia');
CALL MatricularAluno('Tatiane', 'Nascimento', '2015-02-26', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Leonardo', 'Dias', '2016-03-27', 'Direito', 'Humanas');
CALL MatricularAluno('Cristina', 'Ferreira', '2017-04-28', 'Medicina', 'Saúde');
CALL MatricularAluno('Rafaela', 'Dias', '2018-05-29', 'Administração', 'Negócios');
CALL MatricularAluno('Marcelo', 'Santos', '2019-06-30', 'Psicologia', 'Ciências Sociais');
CALL MatricularAluno('Diego', 'Goes', '2020-07-01', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Sabrina', 'Oliveira', '2021-08-02', 'Arquitetura', 'Artes');
CALL MatricularAluno('Raquel', 'Silva', '2022-09-03', 'Biologia', 'Ciências Naturais');
CALL MatricularAluno('Thales', 'Martins', '2023-10-04', 'Economia', 'Negócios');
CALL MatricularAluno('Carolina', 'Silva', '2024-11-05', 'Física', 'Ciências Exatas');
CALL MatricularAluno('Vinícius', 'Sousa', '2025-12-06', 'Química', 'Ciências Exatas');
CALL MatricularAluno('Gabriel', 'Goes', '1990-01-01', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Aline', 'Almeida', '1991-02-02', 'Direito', 'Humanas');
CALL MatricularAluno('Pedro', 'Dias', '1992-03-03', 'Medicina', 'Saúde');
CALL MatricularAluno('Ana', 'Silva', '1993-04-04', 'Administração', 'Negócios');
CALL MatricularAluno('Lucas', 'Dias', '1994-05-05', 'Psicologia', 'Ciências Sociais');
CALL MatricularAluno('Mariana', 'Martins', '1995-06-06', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Fernando', 'Goes', '1996-07-07', 'Arquitetura', 'Artes');
CALL MatricularAluno('Amanda', 'Oliveira', '1997-08-08', 'Biologia', 'Ciências Naturais');
CALL MatricularAluno('Rafael', 'Sousa', '1998-09-09', 'Economia', 'Negócios');
CALL MatricularAluno('Juliana', 'Almeida', '1999-10-10', 'Física', 'Ciências Exatas');
CALL MatricularAluno('Gabriela', 'Nascimento', '2000-11-11', 'Química', 'Ciências Exatas');
CALL MatricularAluno('Bruno', 'Santana', '2001-12-12', 'História', 'Humanas');
CALL MatricularAluno('Marcela', 'Gomes', '2002-01-13', 'Letras', 'Humanas');
CALL MatricularAluno('Roberto', 'Martins', '2003-02-14', 'Matemática', 'Ciências Exatas');
CALL MatricularAluno('Camila', 'Ferreira', '2004-03-15', 'Filosofia', 'Humanas');
CALL MatricularAluno('Ricardo', 'Sousa', '2005-04-16', 'Sociologia', 'Ciências Sociais');
CALL MatricularAluno('Tatiane', 'Lima', '2006-05-17', 'Educação Física', 'Educação');
CALL MatricularAluno('Daniel', 'Mendes', '2007-06-18', 'Nutrição', 'Saúde');
CALL MatricularAluno('Mariana', 'Almeida', '2008-07-19', 'Geografia', 'Ciências Sociais');
CALL MatricularAluno('Paulo', 'Ferreira', '2009-08-20', 'Computação', 'Tecnologia');
CALL MatricularAluno('Carla', 'Sousa', '2010-09-21', 'Artes Visuais', 'Artes');
CALL MatricularAluno('Pedro', 'Martins', '2011-10-22', 'Engenharia Elétrica', 'Engenharia');
CALL MatricularAluno('Lucas', 'Oliveira', '2012-11-23', 'Odontologia', 'Saúde');
CALL MatricularAluno('Patrícia', 'Silva', '2013-12-24', 'Arqueologia', 'Humanas');
CALL MatricularAluno('Rafael', 'Sousa', '2014-01-25', 'Ciência da Computação', 'Tecnologia');
CALL MatricularAluno('Mariana', 'Nascimento', '2015-02-26', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Luiz', 'Martins', '2016-03-27', 'Direito', 'Humanas');
CALL MatricularAluno('Camila', 'Ferreira', '2017-04-28', 'Medicina', 'Saúde');
CALL MatricularAluno('Ricardo', 'Santos', '2018-05-29', 'Administração', 'Negócios');
CALL MatricularAluno('Patrícia', 'Martins', '2019-06-30', 'Psicologia', 'Ciências Sociais');
CALL MatricularAluno('Gustavo', 'Lima', '2020-07-01', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Amanda', 'Oliveira', '2021-08-02', 'Arquitetura', 'Artes');
CALL MatricularAluno('Lucas', 'Ferreira', '2022-09-03', 'Biologia', 'Ciências Naturais');
CALL MatricularAluno('Mariana', 'Martins', '2023-10-04', 'Economia', 'Negócios');
CALL MatricularAluno('Fernando', 'Silva', '2024-11-05', 'Física', 'Ciências Exatas');
CALL MatricularAluno('Gabriel', 'Sousa', '2025-12-06', 'Química', 'Ciências Exatas');
CALL MatricularAluno('Ana', 'Fernandes', '1990-01-01', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Roberto', 'Almeida', '1991-02-02', 'Direito', 'Humanas');
CALL MatricularAluno('Juliana', 'Santos', '1992-03-03', 'Medicina', 'Saúde');
CALL MatricularAluno('Gustavo', 'Candido', '1993-04-04', 'Administração', 'Negócios');
CALL MatricularAluno('Isabela', 'Venturini', '1994-05-05', 'Psicologia', 'Ciências Sociais');
CALL MatricularAluno('Vinícius', 'Jorge', '1995-06-06', 'Engenharia Mecânica', 'Engenharia');

select * from aluno
