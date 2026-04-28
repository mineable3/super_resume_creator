// Changes what type of parsing to use depending on what input is used
// and returns the dictionary 
#let getting_data() = {
    if sys.inputs.at("json", default: "") != "" {
        return json(sys.inputs.at("json", default: ""))
    } else if sys.inputs.at("yaml", default: "") != "" {
        return yaml(sys.inputs.at("yaml", default: ""))
    }
}

// Get data from data yaml file
#let data = getting_data()

// ==================== Set up ============================
#set page(
    paper: "us-letter",
    margin: (
        top: 24pt,
        right: 26pt,
        bottom: 6pt,
        left: 26pt,
    )
)
#set text(
    font: "Liberation Serif",
    size: 11.5pt,
    tracking: -0.01em
)

#set par(
    leading: 0.4em,
    spacing: 0.4em,
)

#show heading: set text(size: 13pt)
#show heading: set block(above: 0.0em, below: 0.2em)
#show heading: it => block(above: 0.0em, below: 0.4em)[
    #it
    #line(length: 100%, stroke: (thickness: 0.1pt))
]

#let heading_spacing = 0.5em
#let sectionIndent = 1.0em

// #show link: set text(fill: rgb("#0055cc"))
#show link: set text(fill: rgb("#000000"))
#show link: display => underline(offset: 2pt)[#display]

// ========================== Name at the top ==========================
#[
    #set text(
        weight: "extrabold",
        size: 17pt,
    )
    #set align(center)
    #data.author
]

// ========================== Contact and links bar ==========================
#{
    set align(center)

    let first = true
    
    // Email is required
    data.contact.email

    if "phone" in data.contact [
        | #data.contact.phone
    ]
    if "location" in data.contact [
        | #data.contact.location
    ]
    if "linkedIn" in data.contact [
        | #link("https://"+data.contact.linkedIn, data.contact.linkedIn)
    ]
    if "github" in data.contact [
        | #link("https://"+data.contact.github, data.contact.github)
    ]
    if "website" in data.contact [
        | #link("https://"+data.contact.website, data.contact.website)
    ]
    
    v(0.1em)
}

// ========================== Education ==========================

#let educationSection() = {
    for institution in data.education.schools {
        // School and location
        grid(
            columns: (1fr, 1fr),
            {
                set text(weight: "bold")
                institution.university
            },
            {
                set align(right)
                set text(weight: "regular")
                institution.location
                h(0.8em)
            }
        )
        
        for degree in institution.degrees {
            // Major and expected graduation date
            grid(
                columns: (8fr, 2fr),
                {
                    set text(style: "italic")
                    degree.major
                    set text(style: "normal")
                    if "gpa" in degree [
                        , GPA: #degree.gpa
                    ]
                },
                {
                    set align(right)
                    degree.graduation_date
                    h(0.8em)
                }
            )
        }

        if "awards" in data.education {
            text(weight: "bold")[Awards:]

            let i = 0
            for award in data.education.awards {
                // Making sure the last item in the list does NOT have a comma
                if i == data.education.awards.len() - 1 [
                    #award
                ] else [
                    #award,
                ]
                i = i + 1
            }
            [\ ]
        }

        if "coursework" in data.education {
            text(weight: "bold")[Coursework:]

            let i = 0
            for class in data.education.coursework {
                // Making sure the last item in the list does NOT have a comma
                if i == data.education.coursework.len() - 1 [
                    #class
                ] else [
                    #class,
                ]
                i = i + 1
            }
        }

        v(0.2em)
    }
}


// ========================== Technical Skills ==========================
#let technicalSection() = {
    if "programming_languages" in data.technical_skills {
        text(style: "italic")[Languages:]

        let i = 0
        for language in data.technical_skills.programming_languages {
            // Making sure the last item in the list does NOT have a comma
            if i == data.technical_skills.programming_languages.len() - 1 [
                #language 
            ] else [
                #language,
            ]

            i = i + 1
        }
        [\ ]
    }

    if "tools" in data.technical_skills {
        text(style: "italic")[Tools:]

        let i = 0
        for tool in data.technical_skills.tools {
            // Making sure the last item in the list does NOT have a comma
            if i == data.technical_skills.tools.len() - 1 [
                #tool
            ] else [
                #tool,
            ]
            i = i + 1
        }

        [\ ]
    }

    if "libraries" in data.technical_skills {
        text(style: "italic")[Libraries:]

        let i = 0
        for lib in data.technical_skills.libraries {
            // Making sure the last item in the list does NOT have a comma
            if i == data.technical_skills.libraries.len() - 1 [
                #lib
            ] else [
                #lib,
            ]
            i = i + 1
        }

        [\ ]
    }

    if "skills" in data.technical_skills {
        text(style: "italic")[Skills:]

        let i = 0
        for skill in data.technical_skills.skills {
            // Making sure the last item in the list does NOT have a comma
            if i == data.technical_skills.skills.len() - 1 [
                #skill
            ] else [
                #skill,
            ]
            i = i + 1
        }

        [\ ]
    }

}



// ========================== Relevant Projects ==========================
#let projectSection() = {
    let i = 0
    for project in data.projects {
        // Project title
        set text(weight: "bold")
        if "link" in project [
            #link(project.link, project.name) \
        ] else [
            #project.name
        ]

        set text(weight: "medium")
        
        if "description" in project {
            v(0.1em)
            project.description
        }

        v(0.2em)
    
        set list(
            indent: 0.0em,
            body-indent: 0.8em,
            marker: text(14pt, [-], baseline: -2.5pt),
            spacing: 0.3em,
            tight: true,
        )
    
        // List of bullet points
        for bullet in project.bullets [
            - #bullet
        ]
    
        // Making sure the last item in the list does NOT have extra spacing
        if i != data.projects.len() - 1 [
            #v(0.2em)
        ]
    
        i = i + 1
    }
}


// ========================== Extracurriculars ==========================

#let extracurricularSection() = {
    let i = 0
    for club in data.extracurriculars {
        
        grid(
            columns: (1fr, 1fr),
            {
                set text(weight: "bold")
                // Formatting differently if the club has a link or not
                if "link" in club {
                    link(club.link, club.name)
                } else {
                    club.name
                }
            },
            {
                set align(right)
                set text(weight: "regular")
                club.time_period
                h(0.8em)
            }
        )
    
        set par(leading: 0.2em, spacing: 0.4em)
    
        set list(
            indent: 0.0em,
            body-indent: 0.8em,
            marker: text(14pt, [-], baseline: -2.5pt),
            spacing: 0.3em,
            tight: true,
        )
    
        // List of bullet points
        for bullet in club.bullets [
            - #bullet
        ]
    
        // Making sure the last item in the list does NOT have extra spacing
        if i != data.extracurriculars.len() - 1 [
            #v(0.2em)
        ]
    
        i = i + 1
    }
}


// ========================== Work ==========================

#let workSection() = {
    let i = 0
    for job in data.work {
        grid(
            columns: (1fr, 1fr),
            {
                set text(weight: "bold")
                // Formatting differently if the job has a link or not
                if "link" in job {
                    link(job.link, job.company)
                } else {
                    job.company
                }
            },
            {
                set align(right)
                set text(weight: "regular")
                job.time_period
                h(0.8em)
            }
        )
    
        set text(style: "italic")
        // Job title/header
        grid(
            columns: (1fr, 1fr),
            {
                job.title
            },
            {
                set align(right)
                job.location
                h(0.8em)
            }
        )
        set text(style: "normal")
    
        set par(leading: 0.2em, spacing: 0.4em)
    
        set list(
            indent: 0.0em,
            body-indent: 0.8em,
            marker: text(14pt, [-], baseline: -2.5pt),
            spacing: 0.3em,
            tight: true,
        )
    
        // List of bullet points
        for bullet in job.bullets [
            - #bullet
        ]
    
        // Making sure the last item in the list does NOT have extra spacing
        if i != data.work.len() - 1 [
            #v(0.2em)
        ]
    
        i = i + 1
    }
}


// ========================== Displaying sections ==========================

#[
    
    #for section in data.order {
        v(heading_spacing)
        if section == "projects" [
            = Projects
            #pad(left: sectionIndent, projectSection())
        ] else if section == "work" [
            = Work Experience
            #pad(left: sectionIndent, workSection())
        ] else if section == "education" [
            = Education
            #pad(left: sectionIndent, educationSection())
        ] else if section == "extracurriculars" [
            = Extracurriculars
            #pad(left: sectionIndent, extracurricularSection())
        ] else if section == "technical_skills" [
            = Technical Skills
            #pad(left: sectionIndent, technicalSection())
        ]

    }

]
