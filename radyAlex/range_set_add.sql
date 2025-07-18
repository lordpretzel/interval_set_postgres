-- i think this works, test for none types or nulls
CREATE OR REPLACE FUNCTION range_set_add(set1 int4range[], set2 int4range[])
RETURNS int4range[] AS $$
DECLARE
    result int4range[] := '{}';
    i int4range;
    j int4range;
BEGIN
    FOR i IN (SELECT unnest(set1)) LOOP
        FOR j IN (SELECT unnest(set2)) LOOP
            result := array_append(result, int4range((lower(i) + lower(j)), (upper(i) + upper(j)) + 1));
        END LOOP;
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;




-- SELECT (range_set_add(
--   ARRAY[int4range(1,4), int4range(3,6), int4range(6,8)],
--   ARRAY[int4range(2,3), int4range(5,9)]
-- ));


-- SELECT (range_set_add(
--   ARRAY[int4range(1,4), int4range(6,9)],
--   ARRAY[int4range(2,5), int4range(4,8)]
-- ));

-- SELECT (range_set_add(
--   ARRAY[int4range(1,4)],
--   ARRAY[int4range(2,5)]
-- ));
