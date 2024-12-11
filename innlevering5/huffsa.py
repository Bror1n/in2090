import psycopg2

# MERK: Må kjøres med Python 3

user = 'brorjt' # Sett inn ditt UiO-brukernavn ("_priv" blir lagt til under)
pwd = 'uw2V0h1soh' # Sett inn passordet for _priv-brukeren du fikk i en mail

connection = \
    "dbname='" + user + "' " +  \
    "user='" + user + "_priv' " + \
    "port='5432' " +  \
    "host='dbpg-ifi-kurs03.uio.no' " + \
    "password='" + pwd + "'"

def huffsa():
    conn = psycopg2.connect(connection)
    
    ch = 0
    while (ch != 3):
        print("--[ HUFFSA ]--")
        print("Vennligst velg et alternativ:\n 1. Søk etter planet\n 2. Legg inn forsøksresultat\n 3. Avslutt")
        ch = int(input("Valg: "))

        if (ch == 1):
            planet_sok(conn)
        elif (ch == 2):
            legg_inn_resultat(conn)
    
def planet_sok(conn):
    # TODO: Oppg 1
    print("Planet search")
    print("Choose molecules")
    mol1 = input("Choose first molecule")
    mol2 = input("Chose molecule 2")

    query = f"SELECT p.navn, p.masse, s.masse, s.avstand,p.liv FROM planet AS p JOIN stjerne AS s ON(p.stjerne = s.navn) JOIN materie AS m ON(p.navn = m.planet) WHERE m.molekyl LIKE '{mol1.strip()}'"

    if mol2.strip() != "":
        q+= f"AND p.navn IN (SELECT m.planet FROM materie m WHERE molekyl LIKE '{mol2.strip()}')"

    cursor = conn.cursor()
    cursor.execute(query)
    rows = cursor.fetchcall()

    if not rows:
        print("No results")
        return

    print("---RESULTS---")

    for row in rows:
        print("Navn:" + row[0] + "\n")
        print("Planet masse:" +row[1] +"\n")
        print("Stjerne masse:" +row[2] +"\n")
        print("Stjerne avstand:" +row[3]+"\n")
        print("Liv:" +row[4] + "\n")


def legg_inn_resultat(conn):
    # TODO: Oppg 2
    print("Put in result")

    planet = input("Name of planet")
    skummelInp = input("Is it scary j/n")
    skummel = True if skummelInp == "j" else False
    intelligentINp = input("Is it intelligent j/n")
    intelligent = True if intelligentINp == "j" else False
    beskrivelse = input("Gi en beskrivelse til planeten")

    query = f"UPDATE PLANET SET skummel = {skummel},intelligent={intelligent},beskrivelse={beskrivelse} WHERE navn = {planet}"
    
    cursor = conn.cursor() 
    cursor.execute(query)
    conn.commit()
    print("Result updated")

if __name__ == "__main__":
    huffsa()

