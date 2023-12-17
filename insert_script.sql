INSERT INTO musician (name_pseudonym)
VALUES ('Whitney Housten'),('Disturbed'),('Louis Armstrong'),('Metallica');

INSERT INTO musical_genre (name)
VALUES ('pop'),('rock'),('jazz');

INSERT INTO album (name, YEAR)
VALUES ('Seattle 89', '2019'),('Rye the Lightning', '2022'),('Whitney', '1987'),('The Great Summit', '1961'),('Evolution', '2018'),('Divisive', '2020');

INSERT INTO musician_genre_link (genre_id, musician_id)
VALUES ('1', '1'),('2', '2'),('2', '4'), ('3', '1'), ('3', '3');

INSERT INTO musician_album_link (album_id, musician_id)
VALUES ('1', '4'),('2', '4'),('3', '1'),('4', '3'),('5', '2'),('6', '2');

INSERT INTO track (name, duration, album_id)
VALUES ('The Four Horsemen my own', '338', '1'),('Escape own my', '393', '2'),('I Know you So Well', '270', '3'),('Love Is A Contact Sport oh my god', '260', '3'),('My Solitudet', '298', '4'),('Cottontail', '227', '4'),('Watch You Burn', '260', '5'),('Won’t Back Down', '172', '6');

INSERT INTO collection (name, YEAR)
VALUES ('C_WH', '2018'),('C_Metallica', '2022'),('C_LouisA', '1987'),('C_Disturbed', '2022');

INSERT INTO collection_track_link (collection_id, track_id)
VALUES ('1', '4'),('2', '1'),('3', '6'),('4', '8');