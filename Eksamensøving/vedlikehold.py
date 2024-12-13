def vedlikehold(conn,område):
    cursor = conn.cursor()
    query = f"SELECT oid FROM område WHERE navn = {område};"
    cursor.execute(query)
    oids = cursor.fetchcall()
    
    for oid in oids:
        query = f"UPDATE sensor SET vedlikeholdt = CURRENT_TIME WHERE oid = {oid}"
        cursor.execute(query)   
    cursor.close()

    #Løsningsforlsag
    cur = conn.cursor()
    cur.excute("UPDATE sensor"
               "SET vedlikeholdt = current_date"
               f"WHERE oid = (SELECT oid FROM område WHERE NAVN = {område});")
    conn.commit()