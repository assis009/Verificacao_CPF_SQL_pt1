
CREATE PROCEDURE sp_valida_cpf(@cpf CHAR(11), @valido BIT OUTPUT)
	AS
		DECLARE @contador INT,
				@indice INT, 
				@somatoria INT,
				@num1 INT,
				@num2 INT,
				@verifica INT,
				@tamanho INT,
				@resto INT

		SET @contador =0
		SET @indice = 10
		SET @somatoria =0
		SET @tamanho =1

	WHILE (@contador < 9)
	BEGIN
	
		SET @num1 = CONVERT(INT, substring(@cpf, @tamanho, 1))
		SET @somatoria = @somatoria+(@indice*@num1)

		SET @contador = @contador +1
		SET @tamanho = @tamanho+1
		SET @indice = @indice -1
	END

	SET @resto = @somatoria%11

	IF(@resto < 2)
	BEGIN
		SET @num1 = 0
	END

	ELSE
	BEGIN 
		SET @num1 = 11- @resto
	END

--Segundo digito 

	SET @contador =0
	SET @indice = 11
	SET @somatoria =0
	SET @tamanho = 1

	WHILE (@contador < 10)
	BEGIN
		IF(@contador< 9)
		BEGIN
			SET @num2 = CONVERT(INT, substring(@cpf, @tamanho, 1))
			SET @somatoria = @somatoria+(@indice*@num2)

			SET @contador = @contador +1
			SET @tamanho = @tamanho+1
			SET @indice = @indice -1
		END
		
		ELSE
		BEGIN
			SET @somatoria = @somatoria+(@num1*@indice)
			SET @contador = @contador +1
		END
	END

	SET @resto = @somatoria%11

	IF(@resto < 2)
	BEGIN
		SET @num2 = 0
	END

	ELSE
	BEGIN 
		SET @num2 = 11- @resto
	END

-- Verificação se os digitos são iguais aos digitados

IF(@num1 = CONVERT(INT, SUBSTRING(@cpf, 10,1)) AND @num2 = CONVERT(INT, SUBSTRING(@cpf, 11,1)))
BEGIN
	SET @valido = 1
END
ELSE
BEGIN
	SET @valido = 0
END
-- verificação se todos são iguais
SET @contador = 0
SET @num1 = 0
SET @somatoria =0
SET @tamanho = 1
SET @verifica = CONVERT(INT, substring(@cpf, @tamanho, 1))

WHILE(@contador<11)
BEGIN
	SET @contador = @contador+1
	SET @num1 = CONVERT(INT, substring(@cpf, @tamanho, 1))
	SET @tamanho = @tamanho+1
	IF(@num1 = @verifica)
	BEGIN 
		SET @somatoria = @somatoria +1
	END
END
print @somatoria 

IF(@somatoria = 11)
BEGIN
	SET @valido = 0
END
ELSE
BEGIN
	SET @valido = 1
END


-- Teste da procedure
DECLARE @v1 BIT
EXEC sp_valida_cpf '68964006097',
	@v1 OUTPUT
PRINT @v1

