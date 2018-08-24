CREATE OR REPLACE function gregorian_to_jalali(inDateGre date) 
RETURNS TABLE(
    j_date text ,
    j_year text ,
    j_month text ,
    j_day text) 
AS $$

DECLARE 
    jalYear smallint;
    jalMonth smallint;
    jalDay smallint;

    rYear smallint;
    rMonth smallint;
    rDay smallint;

    tmp smallint;
   
    numberDay integer;
    leapCnt integer;

    result text;
    jDay text;
    jMonth text;
    jYear text;

BEGIN
    jalYear = 1300;
    jalMonth = 1;
    jalDay = 1;
    numberDay = cast (inDateGre - '1921-3-21'::date as integer);
    leapCnt = (numberDay / 1461)::int;
    numberDay = (numberDay % 1461);

    rYear = numberDay / 365;
    if (rYear = 4) then
    	rYear = 3;
    end if;
    numberDay = numberDay - (rYear * 365);

    rMonth = numberDay / 31;
    if (rMonth > 6) then
    	rMonth = 6;
    end if;
    numberDay = numberDay - (31 * rMonth);
    jalMonth = jalMonth + rMonth;
	if(rMonth = 6 and numberDay >= 30) then 
	    rMonth = numberDay / 30;
	    if(rMonth > 5) then
	    	rMonth = 5;
	    end if;
    	numberDay = numberDay - (30 * rMonth);
    	jalMonth = jalMonth + rMonth;
    end if;

    jalDay = jalDay + numberDay;
    jalYear = jalYear + rYear + (leapCnt * 4);


   	jYear = jalYear::text;
    
	if (jalDay < 10) then
		jDay = '0' || jalDay;
	else
		jDay = jalDay::text;
	end if;
	if (jalMonth < 10) then
		jMonth = '0' || jalMonth;
	else
		jMonth = jalMonth::text;
	end if;

	return query select (jYear || '/' || jMonth || '/' || jDay)::text as j_date, jYear as j_year ,jMonth as j_month ,jDay as j_day;
END;
$$ LANGUAGE PLPGSQL;
