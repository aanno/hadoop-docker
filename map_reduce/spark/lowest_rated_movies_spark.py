from pyspark import SparkConf, SparkContext


# Load Movie Names from u.item
def loadMovieNames(line):
    fields = line.split("|")
    return (int(fields[0]), fields[1])

# Take each line of u.data and convert it to (movieID, (rating, 1.0))
def parseInput(line):
    # split string by whitespace
    fields = line.split()
    # return tuple (movieID, (rating, 1.0))
    return (int(fields[1]), (float(fields[2]), 1.0))


if __name__ == "__main__":
    # The main script - create our SparkContext
    conf = SparkConf().setAppName("WorstMovies")
    sc = SparkContext.getOrCreate(conf=conf)


    # Load up the raw u.data file
    lines = sc.textFile("hdfs://namenode:8020/user/root/input/u.data")

    # Convert to (movieID, (rating, 1.0))
    movieRatings = lines.map(parseInput)

    # Load up our movie ID -> movie name lookup table
    movieNames = sc.textFile("hdfs://namenode:8020/user/root/input/u.item").map(loadMovieNames)

    # Reduce to (movieID, (sumOfRatings, totalRatings))
    ratingTotalsAndCount = movieRatings.reduceByKey(
        lambda movie1, movie2: (movie1[0] + movie2[0], movie1[1] + movie2[1])
    )

    # Map to (movieID, averageRating)
    averageRatings = ratingTotalsAndCount.mapValues(
        lambda totalAndCount: totalAndCount[0] / totalAndCount[1]
    )

    # Sort by average rating
    sortedMovies = averageRatings.sortBy(lambda x: x[1])

    # Take the top 10 results
    # results = sortedMovies.take(10)
    results = sortedMovies.join(movieNames).take(10)
    # print(results)

    # Print them out:
    for result in results:
        print(result[0], result[1])
