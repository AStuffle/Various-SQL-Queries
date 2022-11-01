SELECT
    MAXIMO.inventory.itemnum AS "Item Num",
    MAXIMO.item.description AS "Item Description",
    MAXIMO.invbalances.curbal AS "Current Balance",    
    MAXIMO.inventory.minlevel AS "Min Level",
    MAXIMO.inventory.orderqty "Order Quantity",
    MAXIMO.invbalances.binnum AS "Bin Num.",
    MAXIMO.companies.name AS "Vendor Name",
    MAXIMO.item.itemgroup AS "Item Category",
    '0' AS "Order"
FROM MAXIMO.inventory
LEFT JOIN MAXIMO.companies
    ON inventory.vendor = maximo.companies.company
LEFT JOIN MAXIMO.invbalances
    ON MAXIMO.inventory.itemnum = maximo.invbalances.itemnum
LEFT JOIN MAXIMO.item
    ON MAXIMO.inventory.itemnum = MAXIMO.item.itemnum
WHERE MAXIMO.inventory.location = '16'
    AND MAXIMO.invbalances.location = '16'
    --This seems like a good thing to have, but doesn't match the Maximo report
    --AND MAXIMO.inventory.invclass = 'Replenishable'
    AND MAXIMO.inventory.status = 'ACTIVE'
    AND MAXIMO.invbalances.curbal <= MAXIMO.inventory.minlevel
ORDER BY MAXIMO.companies.name, (MAXIMO.inventory.minlevel - MAXIMO.invbalances.curbal) DESC
