# Laby Client API Wiki

This is the official wiki for the **Laby Client API**.
It contains guides, documentation, and examples on how to use and extend the API.

## Contributing

Have you found something missing from this wiki that you think is important, or are you unhappy with something?
We welcome contributions! Simply fork this repository, add or improve the content, and then open a pull request.

Please make sure your changes are clear, well-formatted, and accurate before submitting.

## Live Build

The live version of this wiki can be found [here](https://dev.labymod.net).

## Preview Locally

To run the wiki locally, follow these steps:

### Requirements
- [Python](https://www.python.org/downloads/) (3.8 or higher recommended)
- [pip](https://pip.pypa.io/en/stable/)

### Setup

1. **Create a virtual environment**

   ```bash
   python -m venv .venv
   ```

2. **Activate the virtual environment**

   ```bash
   # Windows (cmd)
   .venv\Scripts\activate.bat

   # macOS / Linux
   source .venv/bin/activate
   ```

3. **Install dependencies**

   ```bash
   pip install -r requirements.txt
   ```

4. **Start the development server**

   ```bash
   mkdocs serve
   ```

   The wiki will now be available at http://127.0.0.1:8000.