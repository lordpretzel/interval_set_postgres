CREATE OR REPLACE FUNCTION range_add(l int[], r int[])
 RETURNS int[] AS $$
 BEGIN
 RETURN ARRAY[l[1] + r[1], l[2] + r[2]];
 END;
 $$ LANGUAGE plpgsql;