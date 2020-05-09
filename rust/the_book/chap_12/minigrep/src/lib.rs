use std::env;
use std::error::Error;
use std::fs;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn one_result() {
        let query = "duct";
        let contents = "\
Rust: 
fast, mostly safe, productive.
Duct";

        assert_eq!(
            vec!["fast, mostly safe, productive."],
            search(query, contents)
        );
    }

    #[test]
    fn case_insensitive() {
        let query = "ducT";
        let contents = "\
Rust: 
fast, mostly safe, productive.
Duct";

        assert_eq!(
            vec!["fast, mostly safe, productive.", "Duct"],
            search_case_insensitive(query, contents)
        )
    }
}

pub struct Config {
    pub query: String,
    pub filename: String,
    pub case_sensitive: bool,
}

impl Config {
    pub fn new(mut args: std::env::Args) -> Result<Config, &'static str> {
        args.next(); // Discard the exec's name.

        let query = match args.next() {
            Some(arg) => arg,
            None => return Err("Received No Query String"),
        };

        let filename = match args.next() {
            Some(arg) => arg,
            None => return Err("Received No Filename"),
        };

        let case_sensitive = env::var("CASE_INSENSITIVE").is_err();
        Ok(Config {
            query,
            filename,
            case_sensitive,
        })
    }

    pub fn search<'a>(&self, contents: &'a str) -> Vec<&'a str> {
        if self.case_sensitive {
            search(&self.query, contents)
        } else {
            search_case_insensitive(&self.query, contents)
        }
    }
}

pub fn run(config: Config) -> Result<(), Box<dyn Error>> {
    let contents = fs::read_to_string(config.filename.clone())?;
    let results = config.search(&contents);
    for line in results {
        println!("{}", line);
    }

    Ok(())
}

pub fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    contents
        .lines()
        .filter(|line| line.contains(query))
        .collect()

    // let mut results = Vec::new();
    // for line in contents.lines() {
    //     if line.contains(query) {
    //         results.push(line);
    //     }
    // }
    // results
}

pub fn search_case_insensitive<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    let lc_query = query.to_lowercase();

    contents
    .lines()
    .filter(|line| line.to_lowercase().contains(&lc_query))
    .collect()

    // let mut results = Vec::new();
    // for line in contents.lines() {
    //     if line.to_lowercase().contains(&lc_query) {
    //         results.push(line);
    //     }
    // }
    // results
}
