SELECT * FROM
(
select mu.customer_id, SUM(tbo.price)
from `mst_auction` as ma
join `mst_item` as mi
on ma.id = mi.auction_id
join 
(
SELECT o.* FROM `trn_bid_order` o
join (
SELECT MAX(id) as id FROM `trn_bid_order`
GROUP BY item_id) a ON o.id = a.id
)
 as tbo
on tbo.item_id = mi.id
join `mst_users` as mu
on mu.id = user_id
group by customer_id;
)

SELECT * FROM
(
select mu.customer_id, SUM(tbo.price)
from `mst_auction` as ma
join `mst_item` as mi
on ma.id = mi.auction_id
join 
(
SELECT o.* FROM `trn_bid_order` o
join (
SELECT MAX(id) as id FROM `trn_bid_order`
GROUP BY item_id) a ON o.id = a.id
)
 as tbo
on tbo.item_id = mi.id
join `mst_users` as mu
on mu.id = user_id
group by customer_id
);

trn_bid_orderSELECT customer_id, SUM(received_amount) - SUM(spent_amount)  FROM `trn_auction_coupon`
GROUP BY customer_id

----------------------------------------------------------------------------------------------------
SELECT o.* FROM `trn_bid_order` o
join (
SELECT MAX(id) as id FROM `trn_bid_order`
GROUP BY item_id) a ON o.id = a.id;

select mu.customer_id, sum(price), mc.name
from `mst_auction` as ma
join `mst_item` as mi
on ma.id = mi.auction_id
join (
	SELECT o.* FROM `trn_bid_order` o
		join (
		SELECT MAX(id) as id FROM `trn_bid_order`
		GROUP BY item_id) a ON o.id = a.id
) as tbo
on mi.id = tbo.item_id 
join `mst_users` as mu
on mu.id = tbo.user_id
join `mst_customer` as mc
on mc.id = mu.customer_id
group by mu.customer_id
----------------------------------------------------------------------------------------------------
select mu.customer_id, sum(price) as total, mc.name, (select SUM(received_amount) - SUM(spent_amount) from `trn_auction_coupon` as tac2 where tac2.customer_id = tac.customer_id group by tac2.customer_id ) as balance
from `mst_auction` as ma
join `mst_item` as mi
on ma.id = mi.auction_id
join (
	SELECT o.* FROM `trn_bid_order` o
		join (
		SELECT MAX(id) as id FROM `trn_bid_order`
		GROUP BY item_id) a ON o.id = a.id
) as tbo
on mi.id = tbo.item_id 
join `mst_users` as mu
on mu.id = tbo.user_id
join `mst_customer` as mc
on mc.id = mu.customer_id
left join `trn_auction_coupon` as tac
on tac.customer_id = mu.customer_id
group by mu.customer_id
--------------------------------------------------------------------------------------------------------
select 
		ma.id,
		mu.customer_id, 
		sum(price) as total, mc.name, 
		tac.id,
   	tac.received_amount,
      tac.spent_amount,
		(select SUM(received_amount) - SUM(spent_amount) 
			from `trn_auction_coupon` as tac2 
			where tac2.customer_id = tac.customer_id 
			group by tac2.customer_id ) as balance
from `mst_auction` as ma
join `mst_item` as mi
on ma.id = mi.auction_id
join (
	SELECT o.* FROM `trn_bid_order` o
		join (
		SELECT MAX(id) as id FROM `trn_bid_order`
		GROUP BY item_id) a ON o.id = a.id
) as tbo
on mi.id = tbo.item_id 
join `mst_users` as mu
on mu.id = tbo.user_id
join `mst_customer` as mc
on mc.id = mu.customer_id
left join `trn_auction_coupon` as tac
on tac.customer_id = mu.customer_id and tac.auction_id = ma.id
group by mu.customer_id, ma.id;
