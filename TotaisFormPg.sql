select
    cast(sum(iif(cr.tipopgto like '%DINHEIRO%',cr.valortitulo + iif(cr.totalsobra < 0, cr.totalsobra, 0),0)) as decimal(16,2)) as DINHEIRO,
    cast(sum(iif(cr.tipopgto like '%PIX%',cr.valortitulo,0)) as decimal(16,2)) as TOTALPIX,
    cast(sum(iif(cr.tipopgto like '%PIX%' and cr.formpgto like '%Brazil%',cr.valortitulo,0)) as decimal(16,2)) as PIXBRAZIL,
    cast(sum(iif(cr.tipopgto like '%PIX%' and cr.formpgto like '%Caixa%',cr.valortitulo,0)) as decimal(16,2)) as PIXCAIXA,
    cast(sum(iif(cr.tipopgto like '%PIX%' and cr.formpgto like '%C6%',cr.valortitulo,0)) as decimal(16,2)) as PIXC6,
    cast(sum(iif(cr.tipopgto like '%CARTAO%',cr.valortitulo,0)) as decimal(16,2)) as TOTALCARTAO,
    cast(sum(iif(cr.tipopgto like '%CREDSHOP%',cr.valortitulo,0)) as decimal(16,2)) as CARTAOCREDSHOP,
    cast(sum(iif(cr.tipopgto like '%LINK%',cr.valortitulo,0)) as decimal(16,2)) as CARTAOLINK
from tbconta_receber cr
where cr.dataemissao between :pDTInicio and :pDTFim
