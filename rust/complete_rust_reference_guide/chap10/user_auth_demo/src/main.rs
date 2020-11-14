use log::debug;

use user_auth::User;

fn main() {
    env_logger::init();
    debug!("env logger demo started");
    let u = User::new("puppy", "d0g");
    u.sign_in("dog");
    u.sign_in("d0g");
}
