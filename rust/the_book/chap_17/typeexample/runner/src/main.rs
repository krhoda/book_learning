use post;

fn main() {
    let mut new_draft = post::Post::new();

    new_draft.add_text("I saw a puppy today.");

    let review_post = new_draft.request_review();

    let final_post = review_post.approve();

    assert_eq!("I saw a puppy today.", final_post.content());
}
