-- using int4range instead of int[][], since int4range is more suitable for range comparison.
CREATE OR REPLACE FUNCTION compare_range_sets(
    set1 int4range[],
    set2 int4range[],
    operator text
) RETURNS boolean[] AS $$
DECLARE
    result boolean[];
BEGIN
    result := ARRAY[]::boolean[];
    FOR i IN 1..array_length(set1, 1) LOOP
        IF operator = '<' THEN
            result := array_append(result, set1[i] < set2[i]);
        ELSIF operator = '>' THEN
            result := array_append(result, set1[i] > set2[i]);
        ELSIF operator = '=' THEN
            result := array_append(result, set1[i] = set2[i]);
        ELSE
            RAISE EXCEPTION 'Invalid operator. Use <, >, or =';
        END IF;
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Example usage of the compare_range_sets function
-- SELECT compare_range_sets(
--      ARRAY['[100,200]'::int4range, '[1,3]'::int4range, '[500,700]'::int4range],
--      ARRAY['[900,1000]'::int4range, '[2000,5000]'::int4range, '[2,2]'::int4range],
--      '<'
-- );

-- SELECT compare_range_sets(
--     ARRAY['[100,200]'::int4range, '[1,3]'::int4range, '[500,700]'::int4range],
--     ARRAY['[900,1000]'::int4range, '[2000,5000]'::int4range, '[2,2]'::int4range],
--     '>'
-- );

-- SELECT compare_range_sets(
--     ARRAY['[100,200]'::int4range, '[1,3]'::int4range, '[500,700]'::int4range],