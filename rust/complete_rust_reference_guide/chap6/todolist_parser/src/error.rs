use std::error::Error;
use std::fmt;
use std::fmt::Display;

#[derive(Debug)]
pub enum ParseErr {
    Malformed,
    Empty
}

#[derive(Debug)]
pub struct ReadErr {
    pub child_err: Box<dyn Error>
}

impl Display for ReadErr {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Todo List parsing failed")
    }
}

impl Display for ParseErr {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Todo List parsing failed")
    }
}

impl Error for ReadErr {
    fn description(&self) -> &str {
        "Todo List Read Failed: "
    }

    fn cause(&self) -> Option<&dyn Error> {
        Some(&*self.child_err)
    }
}

impl Error for ParseErr {
    fn description(&self) -> &str {
        "Todolist parse failed"
    }

    fn cause(&self) -> Option<&dyn Error> {
        None
    }
}