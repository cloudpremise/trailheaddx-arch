@RestResource(urlMapping='/api/*')
global with sharing class Api  {
    @HttpGet
    global static List<BoxOfficeResult> handleGet()
    {
        Movie mov = new Movie();
        mov.movieName = 'Space Saga 8';
        Theater theater = new Theater();
        theater.theaterName = 'Dallas Landmark';
        
        BoxOfficeResult bor = new BoxOfficeResult();
        bor.movie = mov;
        bor.theater = theater;
        bor.resultDate = Date.today();
        bor.result = 55012.13;
        List<BoxOfficeResult> bors = new List<BoxOfficeResult>();
        bors.add(bor);
        return bors;
    }
    @HttpPost
    global static String handlePost()
    {
        List<BoxOfficeResult> bors = (List<BoxOfficeResult>)JSON.deserialize(RestContext.request.requestBody.toString(), List<BoxOfficeResult>.class);
        Set<String> movieNames = new Set<String>();
        Set<String> theaterNames = new Set<String>();
        for(BoxOfficeResult bor : bors){
            movieNames.add(bor.movie.movieName);
            theaterNames.add(bor.theater.theaterName);
        }
        System.debug(theaterNames);
        System.debug(movieNames);

        Map<ID, Movie__c> movieMap = new Map<ID, Movie__c>([SELECT id, Movie_Name__c from Movie__c where Movie_Name__c IN :movieNames]);
        Map<String, Movie__c> moviesByName = new Map<String, Movie__c>();
        for(Movie__c mov : movieMap.values()){
            moviesByName.put(mov.Movie_Name__c, mov);
        }
        Map<ID, Theater__c> theaterMap = new Map<ID, Theater__c>([SELECT id, Theater_Name__c from Theater__c where Theater_Name__c IN :theaterNames]);
        Map<String, Theater__c> theatersByName = new Map<String, Theater__c>();
        for(Theater__c theater : theaterMap.values()){
            theatersByName.put(theater.Theater_Name__c, theater);
        }
        System.debug(moviesByName);
        System.debug(theatersByName);
        
        List<Movie__c> moviesToCreate = new List<Movie__c>();
        List<Theater__c> theatersToCreate = new List<Theater__c>();
        List<Box_Office_Result__c> boxOfficeResultsToCreate = new List<Box_Office_Result__c>();

        for(BoxOfficeResult bor : bors){
            System.debug(bor);

            Movie__c movie = new Movie__c();
            Theater__c theater = new Theater__c();
            if(moviesByName.containsKey(bor.movie.movieName)){
                movie = moviesByName.get(bor.movie.movieName);
            } else {
                movie.Movie_Name__c = bor.movie.movieName;
                moviesToCreate.add(movie);
            }
            if(theatersByName.containsKey(bor.theater.theaterName)){
                theater = theatersByName.get(bor.theater.theaterName);
            } else {
                theater.Theater_Name__c = bor.theater.theaterName;
                theatersToCreate.add(theater);
            }   
            Box_Office_Result__c bo = new Box_Office_Result__c();
            bo.Movie__r = movie;
            bo.Theater__r = theater;
            bo.Results__c = bor.result;
            bo.Date__c = bor.resultDate;
            System.debug(bo);
            System.debug(bo.Movie__r);
            System.debug(bo.Theater__r);
            boxOfficeResultsToCreate.add(bo);
        }
        if(theatersToCreate.size()>0){
            System.debug(theatersToCreate);
            insert theatersToCreate;
            // for(Theater__c theater : theatersToCreate){
            //     theatersByName.put(theather.Name, theater);
            // }
        }
        if(moviesToCreate.size()>0){
            System.debug(moviesToCreate);
            insert moviesToCreate;
            // for(Movie__c movie : moviesToCreate){
            //     moviesByName.put(movie.Name, movie);
            // }            
        }
        if(boxOfficeResultsToCreate.size()>0){
            for(Box_Office_Result__c bor : boxOfficeResultsToCreate){
                System.debug(bor);
                System.debug(bor.Movie__r);
                System.debug(bor.Theater__r);
                   bor.Movie__c = bor.Movie__r.id;
                   bor.Theater__c = bor.Theater__r.id;
            System.debug(bor);
                       }
            System.debug(boxOfficeResultsToCreate);
            insert boxOfficeResultsToCreate;
        }
        System.debug(bors);
        String res = 'Box Office Result Created';
        return res;
    }
    @HttpPut
    global static String handlePut()
    {
        String res = 'This method is not supported';
        return res;
    }
    @HttpDelete
    global static String handleDelete()
    {
        String res = 'This method is not supported';
        return res;
    }

    global class BoxOfficeResult{
        Theater theater {get;set;}
        Movie movie {get;set;}
        Date resultDate {get;set;}
        Decimal result {get;set;}
    }
    global class Theater{
        String theaterName {get;set;}
    }
    global class Movie{
        String movieName {get;set;}
    }
}