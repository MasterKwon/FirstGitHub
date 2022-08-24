DO $$
DECLARE
  cur record;
  ii integer := 0;
BEGIN
  RAISE NOTICE '시작합니다.';

  <<exit_loop>>
  BEGIN
    FOR cur IN (SELECT prtnrid, prtnrnm FROM gprt01mt LIMIT 20) 
      LOOP
        ii := ii + 1;
        raise NOTICE '% >> 매장코드 : %, 매장명 : %', ii, cur.prtnrid, cur.prtnrnm;
      
        IF ii >= 100 THEN
          EXIT exit_loop;
        END IF;
      end LOOP;
    
     RAISE NOTICE '원하지 않는 결과';
  END;  
  
  RAISE NOTICE '원하는 결과';
END $$;