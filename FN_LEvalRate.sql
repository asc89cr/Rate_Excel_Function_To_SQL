USE [Retail_Tmp]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_LEvalRate]    Script Date: 26/10/2017 11:12:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arnold Sandí Calderón
-- Create date: <25-10-2017>
-- Description:	<Función Axuliar para calcular la tasa de interes mensual>
-- =============================================
ALTER FUNCTION  [dbo].[FN_LEvalRate]
(
	-- Add the parameters for the function here
	@Rate DECIMAL(38,20), 
	@NPer DECIMAL(38,20), 
	@Pmt DECIMAL(38,20), 
	@PV DECIMAL(38,20), 
	@dFv DECIMAL(38,20), 
	@Due DECIMAL(38,20)
)
RETURNS DECIMAL(38,20)
AS
BEGIN
	DECLARE @num1 DECIMAL(38,20),
			@num2 DECIMAL(38,20),
			@result DECIMAL(38,20)

	IF (@Rate = 0.0)
	BEGIN
		SELECT @result = @PV + @Pmt * @NPer + @dFv;
	END
	ELSE
	BEGIN

		SELECT @num1 = POWER(@Rate + 1.0, @NPer);
			 
		SELECT @num2 = CASE WHEN @Due = 1 THEN 1.0 ELSE 1.0 + @Rate END
			
		SELECT @result = @PV * @num1 + @Pmt * @num2 * (@num1 - 1.0) / @Rate + @dFv;
	END

	RETURN @result
END
