USE [Retail_Tmp]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_Rate]    Script Date: 26/10/2017 11:13:17 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnold Sandí Calderón
-- Create date: <25-10-2017>
-- Description:	<Función para calcular la tasa de interes mensual>
-- =============================================
ALTER FUNCTION  [dbo].[FN_Rate]
(
	-- Add the parameters for the function here
	 @NPer DECIMAL(38,20), 
	 @Pmt DECIMAL(38,20), 
	 @PV DECIMAL(38,20), 
	 @FV DECIMAL(38,20) = 0.0, 
	 @Due DECIMAL(38,20) = 1,
	 @Guess DECIMAL(38,20) = 0.1
)
RETURNS DECIMAL(38,20)
AS
BEGIN

	DECLARE	@Rate1 DECIMAL(38,20),
            @num1 DECIMAL(38,20),
            @Rate2 DECIMAL(38,20),
			@Rate3 DECIMAL(38,20),
            @num2 DECIMAL(38,20),
			@a DECIMAL(38,20),
            @num3 INT,
			@num4 DECIMAL(38,20),
			@num5 DECIMAL(38,20),
			@result DECIMAL(38,20)

			SELECT @Rate1 = @Guess
			SELECT @num1 = dbo.FN_LEvalRate(@Rate1, @NPer, @Pmt, @PV, @FV, @Due)
			SELECT @Rate2 = CASE WHEN @num1 <= 0.0 THEN @Rate1 *2.0 ELSE @Rate1 / 2.0 END
			SELECT @num2 = dbo.FN_LEvalRate(@Rate2, @NPer, @Pmt, @PV, @FV, @Due);
			SELECT @num3 = 0

	WHILE(@num3 <= 39)
	BEGIN
		IF(@num2 = @num1)
		BEGIN
			IF(@Rate2 > @Rate1)
			BEGIN
				SELECT @Rate1 -= 1E-05 
			END
			ELSE
			BEGIN
				SELECT @Rate1 -= -1E-05
			END

			SELECT @num1 = dbo.FN_LEvalRate(@Rate1, @NPer, @Pmt, @PV, @FV, @Due);
			IF(@num2 = @num1)
			BEGIN
				SELECT @result = 0
			END
		END

		SELECT @Rate3 = @Rate2 - (@Rate2 - @Rate1) * @num2 / (@num2 - @num1);
		SELECT @a = dbo.FN_LEvalRate(@Rate3, @NPer, @Pmt, @PV, @FV, @Due);

		IF(ABS(@a) < 1E-07)
		BEGIN
			SELECT @result = @Rate3
		END

		SELECT @num4 = @a
		SELECT @num1 = @num2
        SELECT @num2 = @num4
		SELECT @num5 = @Rate3
		SELECT @Rate1 = @Rate2
        SELECT @Rate2 = @num5
		
		SELECT @num3 =  @num3 + 1
		SELECT @result = @Rate1

	END

	RETURN @result
END
