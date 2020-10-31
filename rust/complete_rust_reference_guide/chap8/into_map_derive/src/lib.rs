extern crate proc_macro;
use proc_macro::TokenStream;
use quote::quote;
use syn::{parse_macro_input, Data, DeriveInput, Fields};

#[proc_macro_derive(IntoMap)]
pub fn into_map_derive(input: TokenStream) -> TokenStream {
    let mut insert_tokens = vec![];
    // Parse input into token stream.
    let parsed_input: DeriveInput = parse_macro_input!(input);
    // get "ident"ifier, IE, struct name
    let struct_name = parsed_input.ident;

    // check the token stream's underlying data type
    match parsed_input.data {
        // If the data is of type struct...
        Data::Struct(s) => {
            // check for fields, if they exist, unwrap into
            // the variable named_fields
            if let Fields::Named(named_fields) = s.fields {
                // extract the names into a, some sort of iter
                let a = named_fields.named;
                // traverse a
                for i in a {
                    // get the name of the field via ident
                    let field = i.ident.unwrap();
                    // ???
                    let insert_token = quote! {
                        map.insert(
                            // Identify field as a template var.
                            // convert name to string
                            stringify!(#field).to_string(),
                            // convert val to string
                            self.#field.to_string()
                        );
                    };
                    // push complete token into intermediate token stream;
                    insert_tokens.push(insert_token);
                }
            }

            
        }

        // ... Else, panic.
        x => panic!("IntoMap is not implemented for: {:?}", x)
    }
    // Use the above function as a template var in the final token stream
    let tokens = quote! {
        use std::collections::BTreeMap;
        use into_map::IntoMap;

        // generate the impl block for what has been given.
        impl IntoMap for #struct_name {
            // Converts given struct to dynamic map
            fn into_map(&self) -> BTreeMap<String, String> {
                let mut map = BTreeMap::new();
                #(#insert_tokens)*
                map
            }
        }
    };

    proc_macro::TokenStream::from(tokens)
}