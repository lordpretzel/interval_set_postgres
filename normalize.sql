CREATE OR REPLACE FUNCTION normalize(rangeset int[][])
RETURNS int[][] AS $$
DECLARE
    result int[][] := '{}';
    sorted_ranges int[][] := '{}';
    range_record int[];
    current_min int;
    current_max int;
BEGIN
    -- Edge case: return empty if input is empty
    IF array_length(rangeset, 1) IS NULL THEN
        RETURN result;
    END IF;

    -- Sort ranges by start value
    SELECT array_agg(r ORDER BY r[1]) INTO sorted_ranges FROM unnest(rangeset) AS r;

    -- Initialize with the first range
    current_min := sorted_ranges[1][1];
    current_max := sorted_ranges[1][2];

    -- Iterate through sorted ranges and merge overlapping ones
    FOR range_record IN SELECT unnest(sorted_ranges) LOOP
        IF range_record[1] <= current_max THEN
            current_max := GREATEST(current_max, range_record[2]);
        ELSE
            result := array_append(result, ARRAY[current_min, current_max]);
            current_min := range_record[1];
            current_max := range_record[2];
        END IF;
    END LOOP;

    -- Append the last range
    result := array_append(result, ARRAY[current_min, current_max]);

    RETURN result;
END;
$$ LANGUAGE plpgsql;
