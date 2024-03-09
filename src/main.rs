use clap::Parser;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct ProgramArguments {
    #[arg(short, long)]
    name: String,
}

fn main() {
    let arguments = ProgramArguments::parse();
    println!("Hello {}!", arguments.name);
}
