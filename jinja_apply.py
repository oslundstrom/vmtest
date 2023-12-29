import sys
from jinja2 import Template

def render_template(template_filename, user_input):
    # Read the Jinja2 template from file
    with open(template_filename, 'r') as file:
        template_string = file.read()

    # Create a Jinja2 Template object
    template = Template(template_string)

    # Render the template with the input variable
    result = template.render(var=user_input)

    # Print the result
    print(result)

if __name__ == "__main__":
    # Check if the correct number of command-line arguments is provided
    if len(sys.argv) != 2:
        print("Usage: python3 jinja_apply.py <template_filename>")
        sys.exit(1)

    # Get the template filename from the command-line arguments
    template_filename = sys.argv[1]

    # Read the variable from stdin
    user_input = input()

    # Render the template with the input variable
    render_template(template_filename, user_input)
