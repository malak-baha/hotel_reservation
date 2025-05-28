import streamlit as st
import sqlite3
import pandas as pd

# Connexion à la base
def connecter_db():
    return sqlite3.connect("hotel_reservation.db")

# Affichage des réservations
def afficher_reservations():
    conn = connecter_db()
    cur = conn.cursor()
    cur.execute("""
        SELECT r.idReservation, c.nom, r.dateDebut, r.dateFin
        FROM Reservation r
        JOIN Client c ON r.idClient = c.idClient
    """)
    data = cur.fetchall()
    df = pd.DataFrame(data, columns=["ID Réservation", "Nom Client", "Date Début", "Date Fin"])
    st.subheader("📅 Réservations")
    st.dataframe(df)
    conn.close()

# Affichage des clients
def afficher_clients():
    conn = connecter_db()
    cur = conn.cursor()
    cur.execute("SELECT * FROM Client")
    data = cur.fetchall()
    df = pd.DataFrame(data, columns=["ID", "Adresse", "Ville", "Code Postal", "Email", "Téléphone", "Nom"])
    st.subheader("👤 Clients")
    st.dataframe(df)
    conn.close()

# Chambres disponibles entre 2 dates
def afficher_chambres_disponibles():
    st.subheader("🏨 Chambres disponibles")
    date_debut = st.date_input("Date début")
    date_fin = st.date_input("Date fin")
    if date_debut >= date_fin:
        st.error("❌ La date de fin doit être après la date de début.")
        return
    conn = connecter_db()
    cur = conn.cursor()
    cur.execute("""
        SELECT DISTINCT ch.idChambre, ch.numero, h.ville, tc.nomType
        FROM Chambre ch
        JOIN Hotel h ON ch.idHotel = h.idHotel
        JOIN TypeChambre tc ON ch.idType = tc.idType
        WHERE ch.idChambre NOT IN (
            SELECT idChambre FROM Reservation
            WHERE NOT (dateFin < ? OR dateDebut > ?)
        )
    """, (date_debut, date_fin))
    data = cur.fetchall()
    df = pd.DataFrame(data, columns=["ID Chambre", "Numéro", "Ville", "Type"])
    st.dataframe(df)
    conn.close()

# Ajouter un client
def ajouter_client():
    st.subheader("➕ Ajouter un client")
    nom = st.text_input("Nom")
    adresse = st.text_input("Adresse")
    ville = st.text_input("Ville")
    code_postal = st.text_input("Code Postal")
    email = st.text_input("Email")
    telephone = st.text_input("Téléphone")
    if st.button("Ajouter"):
        conn = connecter_db()
        cur = conn.cursor()
        cur.execute("INSERT INTO Client (adresse, ville, codePostal, email, telephone, nom) VALUES (?, ?, ?, ?, ?, ?)",
                    (adresse, ville, code_postal, email, telephone, nom))
        conn.commit()
        conn.close()
        st.success("✅ Client ajouté avec succès !")

# Ajouter une réservation
def ajouter_reservation():
    st.subheader("📆 Ajouter une réservation")
    conn = connecter_db()
    cur = conn.cursor()
    cur.execute("SELECT idClient, nom FROM Client")
    clients = cur.fetchall()
    client_dict = {f"{nom} (ID {id})": id for (id, nom) in clients}
    client_select = st.selectbox("Choisir un client", list(client_dict.keys()))
    id_client = client_dict[client_select]

    cur.execute("SELECT idChambre, numero FROM Chambre")
    chambres = cur.fetchall()
    chambre_dict = {f"Chambre {num} (ID {id})": id for (id, num) in chambres}
    chambre_select = st.selectbox("Choisir une chambre", list(chambre_dict.keys()))
    id_chambre = chambre_dict[chambre_select]

    date_debut = st.date_input("Date de début")
    date_fin = st.date_input("Date de fin")

    if st.button("Réserver"):
        cur.execute("INSERT INTO Reservation (dateDebut, dateFin, idClient, idChambre) VALUES (?, ?, ?, ?)",
                    (date_debut, date_fin, id_client, id_chambre))
        conn.commit()
        conn.close()
        st.success("✅ Réservation ajoutée avec succès !")

# Interface principale
st.title("🏨 Système de Réservation d'Hôtel")
choix = st.sidebar.radio("Menu", ["Accueil", "Réservations", "Clients", "Chambres disponibles", "Ajouter client", "Ajouter réservation"])

if choix == "Réservations":
    afficher_reservations()
elif choix == "Clients":
    afficher_clients()
elif choix == "Chambres disponibles":
    afficher_chambres_disponibles()
elif choix == "Ajouter client":
    ajouter_client()
elif choix == "Ajouter réservation":
    ajouter_reservation()
else:
    st.write("Bienvenue dans le système de gestion des réservations d'hôtel.")
