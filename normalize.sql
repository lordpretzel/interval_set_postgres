CREATE OR REPLACE FUNCTION normalize(rangeset int4range[])
RETURNS int4range[] AS $$
DECLARE
    result int4range[];
    current_range int4range;
    merged_ranges int4range[] := '{}';
BEGIN
    -- Sort the rangeset
    result := ARRAY(SELECT * FROM UNNEST(rangeset) ORDER BY lower(unnest), upper(unnest));
    IF array_length(result, 1) IS NULL THEN
        RETURN '{}';
    END IF;
    current_range := result[1];
    FOR i IN 2..array_length(result, 1) LOOP
        IF upper(current_range) >= lower(result[i]) THEN
            current_range := int4range(lower(current_range), GREATEST(upper(current_range), upper(result[i])), '[]');
        ELSE
            merged_ranges := array_append(merged_ranges, current_range);
            current_range := result[i];
        END IF;
    END LOOP;
    merged_ranges := array_append(merged_ranges, current_range);
    RETURN merged_ranges;
END;
$$ LANGUAGE plpgsql;
