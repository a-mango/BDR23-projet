import React, { Component } from 'react';
import SubNavigation from "./SubNavigation";

class SubPage extends Component {
    constructor(props) {
        super(props);
        this.state = {
            subPage: ''
        };
    }

    setSubPage = (subPage) => {
        this.setState({ subPage });
    }

    items() {
        throw new Error('You have to implement the method getItems');
    }

    renderSubPage() {
        throw new Error('You have to implement the method renderSubPage');
    }

    render() {
        const items = this.items();

        return (
            <>
                <SubNavigation items={items} setSubPage={this.setSubPage} />
                {this.renderSubPage()}
            </>
        );
    }
}

export default SubPage;