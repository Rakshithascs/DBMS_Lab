CREATE DATABASE MovieDB;
USE MovieDB;

CREATE TABLE ACTOR (
    Act_id INT PRIMARY KEY,
    Act_Name VARCHAR(50),
    Act_Gender VARCHAR(10)
);

CREATE TABLE DIRECTOR (
    Dir_id INT PRIMARY KEY,
    Dir_Name VARCHAR(50),
    Dir_Phone VARCHAR(15)
);

CREATE TABLE MOVIES (
    Mov_id INT PRIMARY KEY,
    Mov_Title VARCHAR(50),
    Mov_Year INT,
    Mov_Lang VARCHAR(20),
    Dir_id INT,
    FOREIGN KEY (Dir_id) REFERENCES DIRECTOR(Dir_id)
);

CREATE TABLE MOVIE_CAST (
    Act_id INT,
    Mov_id INT,
    Role VARCHAR(50),
    PRIMARY KEY (Act_id, Mov_id),
    FOREIGN KEY (Act_id) REFERENCES ACTOR(Act_id),
    FOREIGN KEY (Mov_id) REFERENCES MOVIES(Mov_id)
);

CREATE TABLE RATING (
    Mov_id INT,
    Rev_Stars INT,
    FOREIGN KEY (Mov_id) REFERENCES MOVIES(Mov_id)
);

-- INSERT DATA
INSERT INTO DIRECTOR VALUES
(1, 'ABCD', '9876543210'),
(2, 'XYZ', '9876543211'),
(3, 'PQR', '9876543212');

INSERT INTO MOVIES VALUES
(101, 'KGF', 2018, 'Kannada', 1),
(102, 'MUNGARU MALE', 1998, 'Kannada', 1),
(103, 'RAAJAKUMARA', 1995, 'Kannada', 2),
(104, 'KANTARA', 2020, 'Kannada', 2),
(105, 'U TURN', 2010, 'Kannada', 3);

INSERT INTO ACTOR VALUES
(201, 'RAJ', 'Male'),
(202, 'PRIYA', 'Female'),
(203, 'ARJUN', 'Male'),
(204, 'SNEHA', 'Female');

INSERT INTO MOVIE_CAST VALUES
(201, 101, 'Hero'),
(201, 102, 'Hero'),
(201, 104, 'Hero'),
(202, 102, 'Heroine'),
(202, 103, 'Heroine'),
(203, 101, 'Villain'),
(203, 104, 'Hero'),
(203, 105, 'Hero'),
(204, 105, 'Heroine');

INSERT INTO RATING VALUES
(101, 4),
(101, 5),
(102, 3),
(103, 4),
(104, 2),
(104, 4),
(105, 5);

-- Q1: List the titles of all movies directed by 'ABCD'.
SELECT Mov_Title FROM MOVIES
WHERE Dir_id IN (SELECT Dir_id FROM DIRECTOR WHERE Dir_Name = 'ABCD');

-- Q2: Find the movie names where one or more actors acted in two or more movies.
SELECT DISTINCT M.Mov_Title
FROM MOVIES M, MOVIE_CAST C
WHERE M.Mov_id = C.Mov_id
AND C.Act_id IN (
    SELECT Act_id FROM MOVIE_CAST GROUP BY Act_id HAVING COUNT(Mov_id) >= 2
);

-- Q3: List all actors who acted in a movie before 2000 and also in a movie after 2015 (use JOIN operation).
SELECT DISTINCT A.Act_Name
FROM ACTOR A
JOIN MOVIE_CAST C1 ON A.Act_id = C1.Act_id
JOIN MOVIES M1 ON C1.Mov_id = M1.Mov_id AND M1.Mov_Year < 2000
JOIN MOVIE_CAST C2 ON A.Act_id = C2.Act_id
JOIN MOVIES M2 ON C2.Mov_id = M2.Mov_id AND M2.Mov_Year > 2015;

-- Q4: Find the title of movies and number of stars for each movie that has at least one rating and find the highest number of stars that movie received. Sort the result by movie title.
SELECT M.Mov_Title, MAX(R.Rev_Stars) AS Highest_Stars
FROM MOVIES M, RATING R
WHERE M.Mov_id = R.Mov_id
GROUP BY M.Mov_Title
ORDER BY M.Mov_Title;

-- Q5: Update rating of all movies directed by 'XYZ' to 5.
UPDATE RATING SET Rev_Stars = 5
WHERE Mov_id IN (
    SELECT Mov_id FROM MOVIES
    WHERE Dir_id IN (SELECT Dir_id FROM DIRECTOR WHERE Dir_Name = 'XYZ')
);

SELECT * FROM RATING;
