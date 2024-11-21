CREATE OR REPLACE FUNCTION compare_range_sets(
    range_set1 int[][],
    range_set2 int[][]
) RETURNS TEXT AS $$
DECLARE
    i int;
    j int;
    comparison_result TEXT;
BEGIN
   
    comparison_result := 'incomparable';

    FOR i IN array_lower(range_set1, 1)..array_upper(range_set1, 1) LOOP
        FOR j IN array_lower(range_set2, 1)..array_upper(range_set2, 1) LOOP
            IF range_set1[i][1] < range_set2[j][1] AND range_set1[i][2] < range_set2[j][2] THEN
                comparison_result := 'smaller';
            ELSIF range_set1[i][1] = range_set2[j][1] AND range_set1[i][2] = range_set2[j][2] THEN
                comparison_result := 'equal';
            ELSIF range_set1[i][1] > range_set2[j][1] AND range_set1[i][2] > range_set2[j][2] THEN
                comparison_result := 'greater';
            END IF;
        END LOOP;
    END LOOP;

    RETURN comparison_result;
END;
$$ LANGUAGE plpgsql;