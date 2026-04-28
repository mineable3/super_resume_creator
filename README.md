#  Resume Creator

The Resume Creator solves two main problems:
1. Editing documents while maintaining the formatting.
2. Keeping track of multiple versions of your resume.

## Installation

Start by making sure you have the prerequisites installed.

### Prerequisites

 - `make`
 - `typst`

Then, clone this repository:

```bash
git clone https://github.com/mineable3/resume_creator.git
```

That's it! This tool is ready to be used.

## Usage

After installation you should have a file structure similar to this:

```
├── data
│   ├── cv.yaml
│   └── resume.json
├── Makefile
├── raw_typst
│   └── resume.typ
└── README.md
```

To create your resumes, run make:

```bash
make
```

Running `make` will iterate through every file in `data/` directory.
A data file will get compiled under the following conditions:
 - The corresponding PDF doesn't exist
 - The data file is newer than its corresponding PDF
 - The resume template is newer than the corresponding PDF

The program will create a `compiled/` directory to store the PDF outputs. Every
file in `data/` should have a corresponding PDF file in the `compiled/`
directory. Now, you should have a file directory similar to the following:

```
├── compiled
│   ├── cv.pdf
│   └── resume.pdf
├── data
│   ├── cv.yaml
│   └── resume.json
├── Makefile
├── raw_typst
│   └── resume.typ
└── README.md
```

To update information in your resume, just edit the corresponding data file.
Make will automatically detect which file has been changed and only recompile
that resume. If you want to change your formatting, edit the `resume.typ`
file. Make will detect your changes and recompile all of your resumes with the
new format.

To delete all compiled PDFs run:

```bash
make clean
```

This requires the yq and jq utilities installed.
To transfer a data file between YAML and JSON:

From YAML to JSON:
```bash
yq . data/data.yaml > data/data.json
```

From JSON to YAML:
```bash
yq -y . data/data.yaml > data/data.json
```

## Resume Data File Documentation

This document outlines the structure and field definitions for the resume data
file. The file is designed to capture professional, academic, and technical
qualifications for job seeking individuals across all fields.

### Root Level Fields

| Field | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `order` | List | Defines the visual sequence of sections in the generated resume. | `[education, technical_skills, projects, extracurriculars, work]` |
| `author` | String | The full name of the resume owner. | `John Doe` |
| `contact` | Object | Dictionary of contact methods and professional links. | See [Contact Object](#contact-object) |
| `education` | Object | Educational history and academic achievements. | See [Education Object](#education-object) |
| `technical_skills` | Object | Categorized technical competencies and tools. | See [Technical Skills Object](#technical-skills-object) |
| `projects` | List | Detailed technical projects with descriptions and links. | See [Entry Structure](#entry-structure) |
| `extracurriculars` | List | Activities, clubs, and organizations. | See [Entry Structure](#entry-structure) |
| `work` | List | Professional employment and internship history. | See [Entry Structure](#entry-structure) |

---

### Object Definitions

#### Contact Object
Used to define communication channels and online presence.
- **`phone`**: Primary telephone number.
- **`email`**: Professional email address.
- **`location`**: City and State of residence.
- **`linkedIn`**: URL to the LinkedIn profile (excluding https://).
- **`github`**: URL to the GitHub account (excluding https://).
- **`website`**: URL to a personal portfolio or blog (excluding https://).

#### Education Object
Contains institutional data and academic highlights.
- **`schools`**: A list of objects containing:
    - `university`: Name of the institution.
    - `location`: City and State.
    - **`degrees`**: A list of objects containing:
        - `major`: The degree and field of study.
        - `gpa`: Cumulative Grade Point Average.
        - `graduation_date`: Expected or actual completion date.
- **`coursework`**: A list of specific relevant classes completed.
- **`awards`**: High-level honors or scholarships received.

#### Technical Skills Object
Categorizes tools and knowledge for quick scanning.
- **`programming_languages`**: Core coding languages (e.g., Python, Rust).
- **`tools`**: Software, OS, and build tools (e.g., Linux, Git, Excel).
- **`skills`**: General professional competencies (e.g., Leadership, Problem Solving).
- **`libraries`**: Specialized software packages (e.g., PyTorch, NumPy).

---

### Entry Structure
The sections for **`projects`**, **`extracurriculars`**, and **`work`** follow a consistent list-of-objects format with the following common keys:

- **`name` / `company`**: The primary title of the entry.
- **`link`**: (Optional) A URL related to the entry.
- **`time_period`**: The date range of involvement (e.g., "August 2021 - July 2025").
- **`location`**: (Optional) City and State.
- **`title`**: (Work only) The specific role or position held.
- **`description`**: (Projects only) A brief summary of the project's purpose.
- **`bullets`**: A list of strings describing specific achievements, technologies used, or responsibilities.
