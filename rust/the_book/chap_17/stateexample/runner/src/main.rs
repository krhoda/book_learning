use post;

fn main() {
    let mut new_post = post::Post::new();

    new_post.add_text("I saw a puppy today.");
    assert_eq!("", new_post.content());

    new_post.request_review();
    assert_eq!("", new_post.content());

    new_post.approve();

    assert_eq!("I saw a puppy today.", new_post.content());
}
