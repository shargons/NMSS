-- SQL Function to Convert Lowercase Strings to Proper Mixed Case
-- This function converts any string to proper mixed case format by:
--   1. Capitalizing the first letter
--   2. Capitalizing any letter that follows a non-letter separator character
--   3. Converting all other letters to lowercase
--
-- Separators (automatically handled): space, hyphen, apostrophe, period, comma, 
--                                      parentheses, brackets, quotes, etc.
-- This approach requires no hardcoding of specific patterns.
--
-- USAGE:
--   SELECT dbo.fn_ProperCase(name_column) FROM table_name
-- ============================================================================

CREATE OR ALTER FUNCTION dbo.fn_ProperCase(@input NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @output NVARCHAR(MAX) = '';
    DECLARE @length INT = LEN(@input);
    DECLARE @i INT = 1;
    DECLARE @char NCHAR(1);
    DECLARE @prevChar NCHAR(1) = ' '; 
    DECLARE @isLetter BIT;
    DECLARE @isPrevSeparator BIT;
    
    -- Handle NULL or empty input
    IF @input IS NULL OR LEN(@input) = 0
        RETURN @input;
    
    -- Process each character
    WHILE @i <= @length
    BEGIN
        SET @char = SUBSTRING(@input, @i, 1);
        
        -- Check if current character is a letter (A-Z, a-z)
        SET @isLetter = CASE 
                          WHEN @char >= 'A' AND @char <= 'Z' THEN 1
                          WHEN @char >= 'a' AND @char <= 'z' THEN 1
                          ELSE 0
                        END;
        
        -- Check if previous character is a separator (non-letter, non-digit)
        SET @isPrevSeparator = CASE 
                                 WHEN @prevChar >= 'A' AND @prevChar <= 'Z' THEN 0
                                 WHEN @prevChar >= 'a' AND @prevChar <= 'z' THEN 0
                                 WHEN @prevChar >= '0' AND @prevChar <= '9' THEN 0
                                 ELSE 1
                               END;
        
        -- Capitalize if: letter AND (first character OR after separator)
        IF @isLetter = 1 AND (@i = 1 OR @isPrevSeparator = 1)
        BEGIN
            SET @output = @output + UPPER(@char);
        END
        -- If it's a letter but not capitalized, make it lowercase
        ELSE IF @isLetter = 1
        BEGIN
            SET @output = @output + LOWER(@char);
        END
        -- Keep non-letter characters as-is
        ELSE
        BEGIN
            SET @output = @output + @char;
        END;
        
        SET @prevChar = @char;
        SET @i = @i + 1;
    END;
    
    RETURN @output;
END;

