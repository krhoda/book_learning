mod media;
use media::Playable;

struct Audio(String);
struct Video(String);

impl media::Playable for Audio {
    fn play(&self) {
        println!("Now playing: {}", self.0)
    }
}

impl media::Playable for Video {
    fn play(&self) {
        println!("Now playing: {}", self.0)
    }
}

fn main() {
    println!("Super player");
    let a = Audio("nevermind.mp3".to_string());
    let v = Video("fear_and_loathing.mkv".to_string());
    a.play();
    v.play();
}