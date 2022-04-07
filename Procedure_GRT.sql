drop procedure grtFogoes;
delimiter //
create procedure grtFogoes(IN pId int)
begin
	declare vDone int default false;
	declare vId char(16) default '';
	declare vGrt smallint(5) default 0;
	declare vPrec bigint(15) default 0;
	
	select tab1.no, tab1.sp, isnull(gar.prdno) from 
	(select no, sp from sqldados.prd where no = pId) tab1 left join sqldados.prdgar gar 
	on (gar.prdno_gar = tab1.no) limit 1 into vId, vPrec, vGrt;
	
	if vGrt = 1 then
		update prd
			set check_digit = check_digit + 1,
			tipoGarantia = 2,
			garantia = 12
		where no = vId;
		set vPrec = vPrec div 100;
		if vPrec <= 300 then
			insert into prdgar values(0,0,1,30000,0,0,0,0,0,0,0,0,0,0,vId,'            4609','');
			insert into prdgar values(0,0,1,30000,0,0,0,0,0,0,0,0,0,0,vId,'            3641','');
			elseif ((vPrec > 300) and (vPrec <= 600)) then
				insert into prdgar values(0,0,30001,60000,0,0,0,0,0,0,0,0,0,0,vId,'            3480','');
				insert into prdgar values(0,0,30001,60000,0,0,0,0,0,0,0,0,0,0,vId,'            3642','');
				elseif ((vPrec > 600) and (vPrec <= 9999)) then 
					insert into prdgar values(0,0,60001,999900,0,0,0,0,0,0,0,0,0,0,vId,'            3481','');
					insert into prdgar values(0,0,60001,999900,0,0,0,0,0,0,0,0,0,0,vId,'            3643','');
		end if;
	end if;
end;
//
call grtFogoes()//
