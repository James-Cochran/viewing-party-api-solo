# Viewing Part API - Solo Project

This is the base repo for the Viewing Party Solo Project for Module 3 in Turing's Software Engineering Program. 

## About this Application

Viewing Party is an application that allows users to explore movies and create a Viewing Party Event that invites users and keeps track of a host. Once completed, this application will collect relevant information about movies from an external API, provide CRUD functionality for creating a Viewing Party and restrict its use to only verified users. 

## Setup

1. Fork and clone the repo
2. Install gem packages: `bundle install`
3. Setup the database: `rails db:{drop,create,migrate,seed}`

Spend some time familiarizing yourself with the functionality and structure of the application so far.

Run the application and test out some endpoints: `rails s`

## Base URL
  Local: `http://localhost:3000`
  Deployed: `https://glacial-falls-86396-b2e9f88a1963.herokuapp.com`

## Endpoints
  Endpoint: `/api/v1/movies`
  Method: `GET`
  Description: Retrieves the top 20 rated movies from The Movie DB API